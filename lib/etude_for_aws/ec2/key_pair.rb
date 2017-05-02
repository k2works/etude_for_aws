module EC2
  class KeyPair
    attr_reader :key_pair_name,:pem_file

    def initialize(config)
      @config = config
      @key_pair_name = @config.yaml['DEV']['EC2']['KEY_PAIR_NAME']
      path = Dir.pwd + @config.yaml['DEV']['EC2']['KEY_PAIR_PATH']
      @pem_file = path + "#{@key_pair_name}.pem"
    end

    def create
      key_pairs_result = @config.client.describe_key_pairs()
      key_pairs = []
      if key_pairs_result.key_pairs.count > 0
        key_pairs_result.key_pairs.each do |key_pair|
          key_pairs << key_pair.key_name
        end
      end

      unless key_pairs.include?(@key_pair_name)
        begin
          key_pair = @config.client.create_key_pair({
                                                        key_name: @key_pair_name
                                                    })
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
      @config.client.delete_key_pair({
                                         key_name: @key_pair_name
                                     })
      FileUtils.rm(@pem_file)
    end
  end
end