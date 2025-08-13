# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

require "methods_context"
require "protocol/redis/methods/counting"

describe Protocol::Redis::Methods::Counting do
	include_context MethodsContext, Protocol::Redis::Methods::Counting
	
	let(:key_name) {"pftest"}
	let(:dest_key) {"pfdest"}
	let(:source_key) {"pfsource"}
	let(:element) {"element1"}
	let(:element2) {"element2"}
	
	with "#pfadd" do
		it "can generate correct arguments with single element" do
			expect(object).to receive(:call).with("PFADD", key_name, element).and_return(1)
			
			expect(object.pfadd(key_name, element)).to be == 1
		end
		
		it "can generate correct arguments with multiple elements" do
			expect(object).to receive(:call).with("PFADD", key_name, element, element2).and_return(1)
			
			expect(object.pfadd(key_name, element, element2)).to be == 1
		end
	end
	
	with "#pfcount" do
		it "can generate correct arguments with single key" do
			expect(object).to receive(:call).with("PFCOUNT", key_name).and_return(5)
			
			expect(object.pfcount(key_name)).to be == 5
		end
		
		it "can generate correct arguments with multiple keys" do
			expect(object).to receive(:call).with("PFCOUNT", key_name, source_key).and_return(10)
			
			expect(object.pfcount(key_name, source_key)).to be == 10
		end
	end
	
	with "#pfmerge" do
		it "can generate correct arguments with single source" do
			expect(object).to receive(:call).with("PFMERGE", dest_key, source_key).and_return("OK")
			
			expect(object.pfmerge(dest_key, source_key)).to be == "OK"
		end
		
		it "can generate correct arguments with multiple sources" do
			expect(object).to receive(:call).with("PFMERGE", dest_key, source_key, key_name).and_return("OK")
			
			expect(object.pfmerge(dest_key, source_key, key_name)).to be == "OK"
		end
	end
end
