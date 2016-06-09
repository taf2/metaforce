module Metaforce
  class Job::CRUD < Job

    def initialize(client, method, args)
      @async = false

      super(client)
      @method, @args = method, args
    end

    def perform
      if @async
        @id = @client.send(@method, *@args).id
      else
        @result = @client.send(@method, *@args)
      end
      super
    end
  end
end
