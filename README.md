# README

Census Data API

This is an API that can be used to retrieve census data information as a JSON response, when given a Zip-code.
It is a RubyOnRails app. There is a live version currently being hosted on Heroku.

Example:
https://census-data-api.herokuapp.com/look_up?zip=90007

The database currently holds population estimates for 2014 and 2015 for a preselected zip code group. It is possible to import more data using the import tool. A CSV file is expected, with the correctly labeled columns.
https://census-data-api.herokuapp.com/import-tool

NOTE: The data was structured in a way that would allow any additional fields to be included in the CoreBasedStatisticalArea CSV file. This allows importing data for other census data and/or data for future years. 
