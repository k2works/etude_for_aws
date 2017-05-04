module CFM
  class NullVpc < Vpc
    def initialize
      super
    end

    def create
    end

    def destroy
    end
  end
end