module EC2
  class KeyPair
    attr_reader :key_pair_name,:pem_file

    def initialize(ec2)
      @config = ec2.config
      @gateway = ec2.gateway
      @key_pair_name = @config.key_pair_name
      path = Dir.pwd + @config.key_pair_path
      @pem_file = path + "#{@key_pair_name}.pem"
    end

    def create
      key_pairs_result = @gateway.select_key_pairs
      key_pairs = []
      if key_pairs_result.key_pairs.count > 0
        key_pairs_result.key_pairs.each do |key_pair|
          key_pairs << key_pair.key_name
        end
      end

      unless key_pairs.include?(@key_pair_name)
        begin
          key_pair = @gateway.create_key_pairs(@key_pair_name)
          puts "Created key pair '#{key_pair.key_name}'."
          puts "\nSHA-1 digest of the DER encoded private key:"
          puts "#{key_pair.key_fingerprint}"
          puts "\nUnencrypted PEM encoded RSA private key:"
          puts "#{key_pair.key_material}"
        rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
          puts "A key pair named '#{@key_pair_name}' already exists."
        end


        File.open(@pem_file, "w") do |file|
          file.puts(key_pair.key_material)
        end
      end
    end

    def delete
      @gateway.delete_key_pairs(@key_pair_name)
      FileUtils.rm(@pem_file)
    end
  end
end