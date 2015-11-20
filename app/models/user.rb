class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable
  mount_uploader :image, ImageUploader

  COLUMN_SEPARATORS = [",", ";", "\t", ":", "|", " "]

  def self.import_members(file)
    first_line = File.open(file.tempfile).first.encode("UTF-8", invalid: :replace)
    first_line = first_line.squish
    return nil unless first_line
    separator = {}
    COLUMN_SEPARATORS.each { |col_sep| separator[col_sep] = first_line.scan(col_sep).length }
    separator = separator.sort { |a, b| b[1] <=> a[1] }
    @col_sep = separator.size > 0 ? separator[0][0] : nil
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    puts(@col_sep.inspect)
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    header = []
    case File.extname(file.original_filename)
      when ".csv" then
        begin
          uploaded_file = File.open(file.path, "r")

          if uploaded_file.read.valid_encoding?
            csv_file = file
          else
            uploaded_file.rewind
            csv = uploaded_file.read.encode("UTF-8", invalid: :replace).gsub!(/\r\n?/, "\n")
            csv_file = Tempfile.new("csv")
            csv_file.write(csv)
            csv_file.close
          end

          parsed_file = Roo::CSV.new(csv_file.path, csv_options: {quote_char: "\"", col_sep: @col_sep})
        rescue CSV::MalformedCSVError
          raise "File is malformed: #{file.original_filename}"
        end
      when ".xlsx" then
        parsed_file = Roo::Excelx.new(file.path)
      when ".ods" then
        parsed_file = Roo::OpenOffice.new(file.path)
      else
        raise "Unknown file type: #{file.original_filename}"
    end

    row_length = parsed_file.map(&:length).max
    first_row = parsed_file.row(1).compact

    first_row.each_with_index do |cell, i|
      if cell =~ /@/
        @email_cell = i
      end
    end

    if @email_cell.present?
      # file without header
      (1..row_length).each do |i|
        if @email_cell == i - 1
          header << "email"
        else
          header << "field_#{i}"
        end
      end
      rows = []
      process_result = Hash.new
      emails = []
      invalid_rows = []
      (1..parsed_file.last_row).each do |i|
        begin
          row = Hash[[header, parsed_file.row(i)].transpose]
          email = row.fetch("email").strip
          email = email.squish
          unless emails.include?(email)
            if email =~ /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/
              rows << row
            else
              row["id"] = i.to_s
              puts "**** wrong email on row #{i} #{row} ****"
              invalid_rows << row
            end
            emails << row.fetch("email")
          end
        rescue => e
          puts "**** #{e.message} on row #{i} ****"
          next
        end
      end
      process_result[:valid_rows] = rows
      process_result[:invalid_rows] = invalid_rows
      return process_result
      # invalid_rows if !invalid_rows.empty?
    else
      header = first_row
      parsed_file.row(2).each_with_index do |cell, i|
        if cell =~ /@/
          @email_cell = i
        end
      end
      header[@email_cell] = "email"
      rows = []
      process_result = Hash.new
      emails = []
      invalid_rows = []
      (2..parsed_file.last_row).each do |i|
        #begin
        puts(parsed_file.row(i).inspect)
          row = Hash[[header, parsed_file.row(i)].transpose]
          email = row.fetch("email").strip
          email = email.squish
          unless emails.include?(email)
            if email =~ /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/
              rows << row
            else
              row["id"] = i.to_s
              puts "**** wrong email on row #{i} #{row} ****"
              invalid_rows << row
            end
            emails << row.fetch("email")
          end
        #rescue => e
          #puts "**** #{e.message} on row #{i} ****"
          #next
        #end
      end
      return rows
      # invalid_rows if !invalid_rows.empty?
    end

    first_row.each_with_index do |cell, i|
      if cell =~ /@/
        @email_cell = i
      end
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        puts(auth.inspect)
        user = User.create(:name => auth.info.name,
                           :remote_photo_url => auth.info.image,
                           :provider => auth.provider,
                           :uid => auth.uid,
                           :email => auth.info.email,
                           :password => Devise.friendly_token[0, 20])
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        puts(data.inspect)
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        user = User.create(
            :provider => access_token.provider,
            :email => data["email"],
            :remote_photo_url => data["image"],
            :uid => access_token.uid,
            :password => Devise.friendly_token[0, 20]
        )
      end
    end
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        puts(auth.inspect)
        puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
        user = User.create(provider: auth.provider,
                           uid: auth.uid,
                           email: auth.uid+"@twitter.com",
                           password: Devise.friendly_token[0, 20]
        )
      end
    end
  end
end


