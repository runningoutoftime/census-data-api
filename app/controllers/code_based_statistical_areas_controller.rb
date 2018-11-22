class CodeBasedStatisticalAreasController < ApplicationController
  require 'csv'

  def import_tool
    # Simple Form to rertieve census data csv files
  end

  def import
    # Import csv files for ZipCode & CodeBasedStatisticalArea models
    if params[:zip_code_file].present? && params[:zip_code_file].path.present?
      zip_codes = []
      CSV.foreach(params[:zip_code_file].path, :encoding => 'iso-8859-1:utf-8', :headers => true) do |row|
        zip = row['ZIP'] || row[0]
        next if zip.nil?
        cbsa = row['CBSA']
        if cbsa == '99999'
          cbsa = nil
        end
        zip_codes << ZipCode.new({
          zip: zip,
          cbsa: cbsa,
          res_ratio: row['RES_RATIO'],
          bus_ratio: row['BUS_RATIO'],
          oth_ratio: row['OTH_RATIO'],
          tot_ratio: row['TOT_RATIO']
        })
      end
      @zip_code_record_count = zip_codes.length
      ZipCode.import(zip_codes)
    end
    if params[:cbsa_file].present? && params[:cbsa_file].path.present?
      code_based_statistical_areas = []
      cbsa_data_fields = []
      CSV.foreach(params[:cbsa_file].path, :encoding => 'iso-8859-1:utf-8', :headers => true) do |row|
        cbsa = row['CBSA'] || row[0]
        next if cbsa.nil?
        cbsa_row = CodeBasedStatisticalArea.create!({
          cbsa: cbsa,
          mdiv: row['MDIV'],
          stcou: row["STCOU"],
          name: row['NAME'],
          lsad: row['LSAD']
        })
        row.headers.each do |key|
          next if ['CBSA', 'MDIV','STCOU', 'NAME', 'LSAD'].include?(key)
          cbsa_data_fields << cbsa_row.cbsa_data_fields.build({
            name: key,
            value: row[key]
          })
        end
        code_based_statistical_areas << cbsa_row
      end
      @cbsa_record_count = code_based_statistical_areas.count
      CbsaDataField.import(cbsa_data_fields)
    end
    @response = (@zip_code_record_count || 0).to_s + " Zip Code Records Imported. "
    @response += (@cbsa_record_count || 0).to_s + " CBSA Records Imported. "
  end

  def census_data_api
    # Given a zip code => return MSA Name, Population 2014, and Population 2015
    z = params[:zip]
    response = {zip: z}
    if z.nil?
      render json: {error: "Missing Zip Parameter!" }
      return
    end
   
    zip_code = ZipCode.find_by_zip(z)
    if zip_code.nil?
      render json: {error: "Zip Code (#{z}) Not Found!" }
      return
    end

    cbsa_code = zip_code.cbsa
    if cbsa_code.nil?
      render json: {error: "No CBSA information found for #{z}" }
      return
    end

    matching_cbsa_records = CodeBasedStatisticalArea.where("cbsa = ? OR mdiv = ?", cbsa_code, cbsa_code).includes(:cbsa_data_fields)

    if matching_cbsa_records.empty?
      render json: {error: "No Matching CBSA records found for #{z}" }
      return
    end

    output = []
    matching_cbsa_records.each do |cbsa_row|
      pop_14_record = cbsa_row.cbsa_data_fields.find{ |d| d.name == 'POPESTIMATE2014' }
      pop_15_record = cbsa_row.cbsa_data_fields.find{ |d| d.name == 'POPESTIMATE2015' }
      pop_14 = pop_14_record.nil? ? "NO DATA" : pop_14_record.value
      pop_15 = pop_15_record.nil? ? "NO DATA" : pop_15_record.value
      output << {"MSA Name" => cbsa_row.name,  "Population 2014" => pop_14, "Population 2015" => pop_15}   
    end
    response[:cbsa_code] = matching_cbsa_records.last.cbsa
    response[:output] = output
    render json: response
  end
end
