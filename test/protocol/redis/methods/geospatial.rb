# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "protocol/redis/methods_context"
require "protocol/redis/methods/geospatial"

describe Protocol::Redis::Methods::Geospatial do
	include_context Protocol::Redis::MethodsContext, Protocol::Redis::Methods::Geospatial
	
	let(:key_name) {"geo_key"}
	let(:longitude) {13.361389}
	let(:latitude) {38.115556}
	let(:longitude2) {15.087269}
	let(:latitude2) {37.502669}
	let(:member) {"Palermo"}
	let(:member2) {"Catania"}
	let(:radius) {200}
	let(:unit) {"km"}
	
	with "#geoadd" do
		it "can generate correct arguments with single location" do
			expect(object).to receive(:call).with("GEOADD", key_name, longitude, latitude, member).and_return(1)
			
			expect(object.geoadd(key_name, longitude, latitude, member)).to be == 1
		end
		
		it "can generate correct arguments with multiple locations" do
			expect(object).to receive(:call).with("GEOADD", key_name, longitude, latitude, member, longitude2, latitude2, member2).and_return(2)
			
			expect(object.geoadd(key_name, longitude, latitude, member, longitude2, latitude2, member2)).to be == 2
		end
	end
	
	with "#geohash" do
		it "can generate correct arguments with single member" do
			expect(object).to receive(:call).with("GEOHASH", key_name, member).and_return(["sqc8b49rny0"])
			
			expect(object.geohash(key_name, member)).to be == ["sqc8b49rny0"]
		end
		
		it "can generate correct arguments with multiple members" do
			expect(object).to receive(:call).with("GEOHASH", key_name, member, member2).and_return(["sqc8b49rny0", "sqdtr74hyu0"])
			
			expect(object.geohash(key_name, member, member2)).to be == ["sqc8b49rny0", "sqdtr74hyu0"]
		end
	end
	
	with "#geopos" do
		it "can generate correct arguments with single member" do
			expect(object).to receive(:call).with("GEOPOS", key_name, member).and_return([[longitude.to_s, latitude.to_s]])
			
			expect(object.geopos(key_name, member)).to be == [[longitude.to_s, latitude.to_s]]
		end
		
		it "can generate correct arguments with multiple members" do
			expect(object).to receive(:call).with("GEOPOS", key_name, member, member2).and_return([[longitude.to_s, latitude.to_s], [longitude2.to_s, latitude2.to_s]])
			
			expect(object.geopos(key_name, member, member2)).to be == [[longitude.to_s, latitude.to_s], [longitude2.to_s, latitude2.to_s]]
		end
	end
	
	with "#geodist" do
		it "can generate correct arguments with default unit" do
			expect(object).to receive(:call).with("GEODIST", key_name, member, member2, "m").and_return("166274.1516")
			
			expect(object.geodist(key_name, member, member2)).to be == "166274.1516"
		end
		
		it "can generate correct arguments with custom unit" do
			expect(object).to receive(:call).with("GEODIST", key_name, member, member2, unit).and_return("166.2742")
			
			expect(object.geodist(key_name, member, member2, unit)).to be == "166.2742"
		end
		
		it "can generate correct arguments with meters unit" do
			expect(object).to receive(:call).with("GEODIST", key_name, member, member2, "m").and_return("166274.1516")
			
			expect(object.geodist(key_name, member, member2, "m")).to be == "166274.1516"
		end
		
		it "can generate correct arguments with kilometers unit" do
			expect(object).to receive(:call).with("GEODIST", key_name, member, member2, "km").and_return("166.2742")
			
			expect(object.geodist(key_name, member, member2, "km")).to be == "166.2742"
		end
		
		it "can generate correct arguments with miles unit" do
			expect(object).to receive(:call).with("GEODIST", key_name, member, member2, "mi").and_return("103.3182")
			
			expect(object.geodist(key_name, member, member2, "mi")).to be == "103.3182"
		end
		
		it "can generate correct arguments with feet unit" do
			expect(object).to receive(:call).with("GEODIST", key_name, member, member2, "ft").and_return("545518.8700")
			
			expect(object.geodist(key_name, member, member2, "ft")).to be == "545518.8700"
		end
	end
	
	with "#georadius" do
		it "can generate correct arguments with basic parameters" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit).and_return([member])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit)).to be == [member]
		end
		
		it "can generate correct arguments with default unit" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, "m").and_return([member])
			
			expect(object.georadius(key_name, longitude, latitude, radius)).to be == [member]
		end
		
		it "can generate correct arguments with coordinates" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "WITHCOORD").and_return([[member, [longitude.to_s, latitude.to_s]]])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, with_coordinates: true)).to be == [[member, [longitude.to_s, latitude.to_s]]]
		end
		
		it "can generate correct arguments with distance" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "WITHDIST").and_return([[member, "0.0000"]])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, with_distance: true)).to be == [[member, "0.0000"]]
		end
		
		it "can generate correct arguments with hash" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "WITHHASH").and_return([[member, 3479099956230698]])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, with_hash: true)).to be == [[member, 3479099956230698]]
		end
		
		it "can generate correct arguments with count" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "COUNT", 1).and_return([member])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, count: 1)).to be == [member]
		end
		
		it "can generate correct arguments with ASC order" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "ASC").and_return([member, member2])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, order: "ASC")).to be == [member, member2]
		end
		
		it "can generate correct arguments with DESC order" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "DESC").and_return([member2, member])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, order: "DESC")).to be == [member2, member]
		end
		
		it "can generate correct arguments with store (write variant)" do
			store_key = "result_key"
			expect(object).to receive(:call).with("GEORADIUS", key_name, longitude, latitude, radius, unit, "STORE", store_key).and_return(1)
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, store: store_key)).to be == 1
		end
		
		it "can generate correct arguments with store_distance (write variant)" do
			store_key = "result_key"
			expect(object).to receive(:call).with("GEORADIUS", key_name, longitude, latitude, radius, unit, "STOREDIST", store_key).and_return(1)
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, store_distance: store_key)).to be == 1
		end
		
		it "can generate correct arguments with multiple WITH options" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "WITHCOORD", "WITHDIST", "WITHHASH").and_return([[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, with_coordinates: true, with_distance: true, with_hash: true)).to be == [[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]]
		end
		
		it "can generate correct arguments with combined options" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "WITHCOORD", "WITHDIST", "COUNT", 5, "ASC").and_return([[member, [longitude.to_s, latitude.to_s], "0.0000"]])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, with_coordinates: true, with_distance: true, count: 5, order: "ASC")).to be == [[member, [longitude.to_s, latitude.to_s], "0.0000"]]
		end
		
		it "can generate correct arguments with all read-only options" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, "WITHCOORD", "WITHDIST", "WITHHASH", "COUNT", 10, "DESC").and_return([[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, with_coordinates: true, with_distance: true, with_hash: true, count: 10, order: "DESC")).to be == [[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]]
		end
		
		it "can generate correct arguments with different units" do
			["m", "km", "mi", "ft"].each do |test_unit|
				expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, test_unit).and_return([member])
				
				expect(object.georadius(key_name, longitude, latitude, radius, test_unit)).to be == [member]
			end
		end
		
		it "can generate correct arguments with store and additional options" do
			store_key = "result_key"
			expect(object).to receive(:call).with("GEORADIUS", key_name, longitude, latitude, radius, unit, "COUNT", 5, "ASC", "STORE", store_key).and_return(1)
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, count: 5, order: "ASC", store: store_key)).to be == 1
		end
		
		it "can generate correct arguments with both store options" do
			store_key = "result_key"
			store_dist_key = "dist_key"
			expect(object).to receive(:call).with("GEORADIUS", key_name, longitude, latitude, radius, unit, "STORE", store_key, "STOREDIST", store_dist_key).and_return(1)
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, store: store_key, store_distance: store_dist_key)).to be == 1
		end
		
		it "can generate correct arguments with symbol order" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, :ASC).and_return([member, member2])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, order: :ASC)).to be == [member, member2]
		end
		
		it "can generate correct arguments with symbol DESC order" do
			expect(object).to receive(:call).with("GEORADIUS_RO", key_name, longitude, latitude, radius, unit, :DESC).and_return([member2, member])
			
			expect(object.georadius(key_name, longitude, latitude, radius, unit, order: :DESC)).to be == [member2, member]
		end
	end
	
	with "#georadiusbymember" do
		it "can generate correct arguments with basic parameters" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit).and_return([member, member2])
			
			expect(object.georadiusbymember(key_name, member, radius, unit)).to be == [member, member2]
		end
		
		it "can generate correct arguments with default unit" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, "m").and_return([member, member2])
			
			expect(object.georadiusbymember(key_name, member, radius)).to be == [member, member2]
		end
		
		it "can generate correct arguments with coordinates" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "WITHCOORD").and_return([[member, [longitude.to_s, latitude.to_s]]])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, with_coordinates: true)).to be == [[member, [longitude.to_s, latitude.to_s]]]
		end
		
		it "can generate correct arguments with distance" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "WITHDIST").and_return([[member, "0.0000"]])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, with_distance: true)).to be == [[member, "0.0000"]]
		end
		
		it "can generate correct arguments with hash" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "WITHHASH").and_return([[member, 3479099956230698]])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, with_hash: true)).to be == [[member, 3479099956230698]]
		end
		
		it "can generate correct arguments with count" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "COUNT", 1).and_return([member])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, count: 1)).to be == [member]
		end
		
		it "can generate correct arguments with ASC order" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "ASC").and_return([member, member2])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, order: "ASC")).to be == [member, member2]
		end
		
		it "can generate correct arguments with DESC order" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "DESC").and_return([member2, member])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, order: "DESC")).to be == [member2, member]
		end
		
		it "can generate correct arguments with store (write variant)" do
			store_key = "result_key"
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER", key_name, member, radius, unit, "STORE", store_key).and_return(1)
			
			expect(object.georadiusbymember(key_name, member, radius, unit, store: store_key)).to be == 1
		end
		
		it "can generate correct arguments with store_distance (write variant)" do
			store_key = "result_key"
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER", key_name, member, radius, unit, "STOREDIST", store_key).and_return(1)
			
			expect(object.georadiusbymember(key_name, member, radius, unit, store_distance: store_key)).to be == 1
		end
		
		it "can generate correct arguments with multiple WITH options" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "WITHCOORD", "WITHDIST", "WITHHASH").and_return([[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, with_coordinates: true, with_distance: true, with_hash: true)).to be == [[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]]
		end
		
		it "can generate correct arguments with combined options" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "WITHCOORD", "WITHDIST", "COUNT", 5, "ASC").and_return([[member, [longitude.to_s, latitude.to_s], "0.0000"]])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, with_coordinates: true, with_distance: true, count: 5, order: "ASC")).to be == [[member, [longitude.to_s, latitude.to_s], "0.0000"]]
		end
		
		it "can generate correct arguments with all read-only options" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, "WITHCOORD", "WITHDIST", "WITHHASH", "COUNT", 10, "DESC").and_return([[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, with_coordinates: true, with_distance: true, with_hash: true, count: 10, order: "DESC")).to be == [[member, [longitude.to_s, latitude.to_s], "0.0000", 3479099956230698]]
		end
		
		it "can generate correct arguments with different units" do
			["m", "km", "mi", "ft"].each do |test_unit|
				expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, test_unit).and_return([member])
				
				expect(object.georadiusbymember(key_name, member, radius, test_unit)).to be == [member]
			end
		end
		
		it "can generate correct arguments with store and additional options" do
			store_key = "result_key"
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER", key_name, member, radius, unit, "COUNT", 5, "ASC", "STORE", store_key).and_return(1)
			
			expect(object.georadiusbymember(key_name, member, radius, unit, count: 5, order: "ASC", store: store_key)).to be == 1
		end
		
		it "can generate correct arguments with both store options" do
			store_key = "result_key"
			store_dist_key = "dist_key"
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER", key_name, member, radius, unit, "STORE", store_key, "STOREDIST", store_dist_key).and_return(1)
			
			expect(object.georadiusbymember(key_name, member, radius, unit, store: store_key, store_distance: store_dist_key)).to be == 1
		end
		
		it "can generate correct arguments with symbol order" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, :ASC).and_return([member, member2])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, order: :ASC)).to be == [member, member2]
		end
		
		it "can generate correct arguments with symbol DESC order" do
			expect(object).to receive(:call).with("GEORADIUSBYMEMBER_RO", key_name, member, radius, unit, :DESC).and_return([member2, member])
			
			expect(object.georadiusbymember(key_name, member, radius, unit, order: :DESC)).to be == [member2, member]
		end
	end
end
