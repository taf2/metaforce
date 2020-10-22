module Metaforce
  module Metadata
    class Client
      module CRUD

        # Public: Create metadata
        #
        # Examples
        #
        #   client._create(:apex_page, :full_name => 'TestPage', label: 'Test page', :content => '<apex:page>foobar</apex:page>')
        # see: https://developer.salesforce.com/page/Metadata_Create_Custom_Field
        def _create(type, metadata={})
          type    = type.to_s.camelize
          message = { metadata: metadata.merge({'@xsi:type' => "tns:#{type}"}) }
          client.call(:create_metadata, message: message)
        end

        # Public: Upsert metadata
        #
        # Examples
        #
        #   client._upsert(:apex_page, :full_name => 'TestPage', :label => 'Test page', :content => '<apex:page>hello world</apex:page>')
        def _upsert(type, metadata={})
          type = type.to_s.camelize
          message = { metadata: metadata.merge({'@xsi:type' => "tns:#{type}"}) }
          client.call(:upsert_metadata, message: message)
        end

        # Public: Delete metadata
        #
        # Examples
        #
        #   client._delete(:apex_component, 'Component')
        def _delete(type, *args)
          type = type.to_s.camelize
          message = { metadata: {full_names: args}.merge({'@xsi:type' => "tns:#{type}"}) }
          client.call(:delete_metadata, message: message)
        end

        # Public: Update metadata
        #
        # Examples
        #
        #   client._update(:apex_page, :full_name => 'TestPage', :label => 'Test page', :content => '<apex:page>hello world</apex:page>')
        def _update(type, metadata={})
          type = type.to_s.camelize
          message = { metadata: metadata.merge({'@xsi:type' => "tns:#{type}"}) }
          client.call(:update_metadata, message: message)
        end

        # Public: Describe metadata
        #
        # Examples
        #
        #   client._describe(:apex_page)
        def _describe(type)
          type = type.to_s.camelize
          client.call(:describe, message: {'@xsi:type' => "tns:#{type}"})
        end

        # Public: Read metadata
        #
        # Examples
        #
        #   client._read(:apex_page, ["MyCustomObject1__c", "MyCustomObject2__c"])
        def _read(type, full_names=[])
          type = type.to_s.camelize
          message = { type: type, fullNames: full_names }
          client.call(:read_metadata, message: message)
        end

        def create(*args)
          Job::CRUD.new(self, :_create, args)
        end

        def update(*args)
          Job::CRUD.new(self, :_update, args)
        end

        def delete(*args)
          Job::CRUD.new(self, :_delete, args)
        end

        def upsert(*args)
          Job::CRUD.new(self, :_upsert, args)
        end

        def describe(*args)
          Job::CRUD.new(self, :_describe, args)
        end

        def read(*args)
          Job::CRUD.new(self, :_read, args)
        end

      private

        # Internal: Prepare metadata by base64 encoding any content keys.
        def prepare(metadata)
          metadata = Array[metadata].compact.flatten
          metadata.each { |m| encode_content(m) }
          metadata
        end

        # Internal: Base64 encodes any :content keys.
        def encode_content(metadata)
          metadata[:content] = Base64.encode64(metadata[:content]) if metadata.has_key?(:content)
        end
        
      end
    end
  end
end
