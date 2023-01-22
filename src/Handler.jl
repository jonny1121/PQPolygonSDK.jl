function _polygon_error_handler(request_body_dictionary::Dict{String, Any})::Tuple

    # initialize -
    error_response_dictionary = Dict{String,Any}()
    
    # what are my error keys?
    error_keys = keys(request_body_dictionary)
    for key ∈ error_keys
        error_response_dictionary[key] = request_body_dictionary[key]
    end

    # return -
    return (error_response_dictionary, nothing)
end

function _process_previous_close_polygon_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        ticker=String[],
        volume=Float64[],
        volume_weighted_average_price=Float64[],
        open=Float64[],
        close=Float64[],
        high=Float64[],
        low=Float64[],
        timestamp=DateTime[],
        number_of_transactions=Int[]
    )

    # fill in the header dictionary -
    header_keys = [
        "ticker", "queryCount", "adjusted", "status", "request_id", "count"
    ]

    # check - do we have a count (if not resturn zero)
    get!(request_body_dictionary, "count", 0)

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check - do we have a resultsCount field?
    results_count = get!(request_body_dictionary, "resultsCount", 0)
    if (results_count == 0) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        
        # build a results tuple -
        result_tuple = (

            ticker = result_dictionary["T"],
            volume = result_dictionary["v"],
            volume_weighted_average_price = result_dictionary["vw"],
            open = result_dictionary["o"],
            close = result_dictionary["c"],
            high = result_dictionary["h"],
            low = result_dictionary["l"],
            timestamp = unix2datetime(result_dictionary["t"]*(1/1000)),
            number_of_transactions = result_dictionary["n"]
        )
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end

function _process_aggregates_polygon_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        volume=Float64[],
        volume_weighted_average_price=Float64[],
        open=Float64[],
        close=Float64[],
        high=Float64[],
        low=Float64[],
        timestamp=DateTime[],
        number_of_transactions=Int[]
    )

    # fill in the header dictionary -
    header_keys = [
        "ticker", "queryCount", "adjusted", "status", "request_id", "count"
    ]

    # check - do we have a count (if not resturn zero)
    get!(request_body_dictionary, "count", 0)
    get!(request_body_dictionary, "ticker", "N/A")

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check - do we have a resultsCount field?
    results_count = get!(request_body_dictionary, "resultsCount", 0)
    if (results_count == 0) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        
        # set some defaults in case missing fields -
        get!(result_dictionary, "vw", 0.0)
        get!(result_dictionary, "n", 0)

        # build a results tuple -
        result_tuple = (

            volume = result_dictionary["v"],
            volume_weighted_average_price = result_dictionary["vw"],
            open = result_dictionary["o"],
            close = result_dictionary["c"],
            high = result_dictionary["h"],
            low = result_dictionary["l"],
            timestamp = unix2datetime(result_dictionary["t"]*(1/1000)),
            number_of_transactions = result_dictionary["n"]
        )
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end

function _process_daily_open_close_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR" || status_flag == "NOT_FOUND")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        ticker=String[],
        volume=Float64[],
        open=Float64[],
        close=Float64[],
        high=Float64[],
        low=Float64[],
        from=Date[],
        afterHours=Float64[],
        preMarket=Float64[]
    )

    header_keys = [
        "status"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # build a results tuple -
    result_tuple = (

        volume = request_body_dictionary["volume"],
        open = request_body_dictionary["open"],
        close = request_body_dictionary["close"],
        high = request_body_dictionary["high"],
        low = request_body_dictionary["low"],
        from = Date(request_body_dictionary["from"]),
        ticker = request_body_dictionary["symbol"],
        afterHours = request_body_dictionary["afterHours"],
        preMarket = request_body_dictionary["preMarket"]
    )

    # push that tuple into the df -
    push!(df, result_tuple)

    # return -
    return (header_dictionary, df)
end

function _process_options_reference_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        cfi=String[],
        contract_type=String[],
        exercise_style=String[],
        expiration_date=Date[],
        primary_exchange=String[],
        shares_per_contract=Int64[],
        strike_price=Float64[],
        ticker = String[],
        underlying_ticker = String[]
    )

    # fill in the header dictionary -
    header_keys = [
        "status", "request_id", "count", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        
        # build a results tuple -
        result_tuple = (

            cfi = result_dictionary["cfi"],
            contract_type = result_dictionary["contract_type"],
            exercise_style = result_dictionary["exercise_style"],
            expiration_date = Date(result_dictionary["expiration_date"]),
            primary_exchange = result_dictionary["primary_exchange"],
            shares_per_contract = result_dictionary["shares_per_contract"],
            strike_price = result_dictionary["strike_price"],
            ticker = result_dictionary["ticker"],
            underlying_ticker = result_dictionary["underlying_ticker"]
        )
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end

function _process_ticker_news_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame();

    # fill in the header dictionary -
    header_keys = [
        "status", "request_id", "count", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # return -
    return (header_dictionary, df)
end

function _process_options_snapshot_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # NOTE: the API doesn't return a consistent set of error conditions,
    # we can put nonsense into the ticker string and status is still ok?

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # build the results dictionary structure -
    base_results_dictionary = request_body_dictionary["results"];

    # return -
    return (header_dictionary, base_results_dictionary)
end

function _process_options_last_trade_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "NOT_FOUND")
        return _polygon_error_handler(request_body_dictionary)
    end

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # build the results dictionary structure -
    base_results_dictionary = request_body_dictionary["results"];

    # return -
    return (header_dictionary, base_results_dictionary)
end

function _process_options_quotes_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # check: do we have a next_url?
    get!(request_body_dictionary, "next_url", "")

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # build a df -
    df = DataFrame()

    # populate the results DataFrame -    
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array  
        
        # build a results tuple -
        result_tuple = (
            
            ask_exchange = result_dictionary["ask_exchange"],
            ask_price = result_dictionary["ask_price"],
            ask_size = result_dictionary["ask_size"],
            bid_exchange = result_dictionary["bid_exchange"],
            bid_price = result_dictionary["bid_price"],
            bid_size = result_dictionary["bid_size"],
            sequence_number = result_dictionary["sequence_number"],
            sip_timestamp = result_dictionary["sip_timestamp"]
        )

        # push that tuple into the df -
        push!(df, result_tuple)
    end 


    # return -
    return (header_dictionary, df)
end

function _process_stock_trades_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # check: do we have a next_url?
    get!(request_body_dictionary, "next_url", "")

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # build a df -
    df = DataFrame()

    # check: if results is empty, then return Nothing in data -
    results_array = request_body_dictionary["results"]
    if (isempty(results_array) == true)
        return _polygon_error_handler(request_body_dictionary)
    end

    # populate the results DataFrame -  
    # process the results -
    for result_dictionary ∈ results_array  
        
        # check: do we have a conditions block?
        get!(result_dictionary, "conditions", [0])
        get!(result_dictionary, "trf_id", 0)

         # handle the conditions array -
         tmp_value_array = result_dictionary["conditions"]
         conditions_array = Array{Int64,1}()
         for value ∈ tmp_value_array
             push!(conditions_array, value)
         end 

        # build a results tuple -
        result_tuple = (
            
            conditions = conditions_array,
            exchange = result_dictionary["exchange"],
            id = result_dictionary["id"],
            price = result_dictionary["price"],
            sequence_number = result_dictionary["sequence_number"],
            sip_timestamp = result_dictionary["sip_timestamp"],
            size_value = result_dictionary["size"],
            tape = result_dictionary["tape"],
            trf_id = result_dictionary["trf_id"]
        )

        # push that tuple into the df -
        push!(df, result_tuple)
    end 

    # return -
    return (header_dictionary, df)
end

function _process_options_trade_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # check: do we have a next_url?
    get!(request_body_dictionary, "next_url", "")

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # build a df -
    df = DataFrame()

    # check: if results is empty, then return Nothing in data -
    results_array = request_body_dictionary["results"]
    if (isempty(results_array) == true)
        return _polygon_error_handler(request_body_dictionary)
    end

    # populate the results DataFrame -  
    # process the results -
    for result_dictionary ∈ results_array  
        
        # check: do we have a conditions block?
        get!(result_dictionary, "conditions", [0])
        get!(result_dictionary, "trf_id", 0)

         # handle the conditions array -
         tmp_value_array = result_dictionary["conditions"]
         conditions_array = Array{Int64,1}()
         for value ∈ tmp_value_array
             push!(conditions_array, value)
         end 

        # build a results tuple -
        result_tuple = (
            
            conditions = conditions_array,
            exchange = result_dictionary["exchange"],
            id = result_dictionary["id"],
            participant_timestamp = result_dictionary["participant_timestamp"],
            price = result_dictionary["price"],
            sequence_number = result_dictionary["sequence_number"],
            sip_timestamp = result_dictionary["sip_timestamp"],
            size_value = result_dictionary["size"]

        )

        # push that tuple into the df -
        push!(df, result_tuple)
    end 

    # return -
    return (header_dictionary, df)
end

# =================================================================================== #
# handlers developed by ycpan1012 -
function _process_ticker_details_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "NOT_FOUND" || status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end
    
    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

            ticker = String[],
            name = String[],
            market = String[],
            locale = String[],
            primary_exchange = String[],
            type = String[],
            active = Bool[],
            currency_name = String[],
            cik = String[],
            composite_figi = String[],
            share_class_figi = String[],
            market_cap = Float64[],
            phone_number = String[],
            address1 = String[],
            city = String[],
            state = String[],
            postal_code = String[],
            description = String[],
            sic_code = String[],
            sic_description = String[],
            ticker_root = String[],
            homepage_url = String[],
            total_employees = Float64[],
            list_date = String[],
            logo_url = String[],
            icon_url = String[],
            share_class_shares_outstanding = Float64[],
            weighted_shares_outstanding = Float64[],
            delisted_utc = String[]
    );
    
    # fill in the header dictionary -
    header_keys = [
        "status", "request_id"
    ];

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # if no results we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    results_array = request_body_dictionary["results"]

    # get if no values
    get!(results_array, "primary_exchange", "N/A")
    get!(results_array, "type", "N/A")
    get!(results_array, "cik", "N/A")
    get!(results_array, "composite_figi", "N/A")
    get!(results_array, "share_class_figi", "N/A")
    get!(results_array, "market_cap", NaN)
    get!(results_array, "phone_number", "N/A")

    # get if no values - address dictionary
    get!(results_array, "address", Dict("address1" => "N/A", "city" => "N/A", "state" => "N/A", "postal_code" => "N/A"))    
    get!(results_array["address"], "address1", "N/A")
    get!(results_array["address"], "city", "N/A")
    get!(results_array["address"], "state", "N/A")
    get!(results_array["address"], "postal_code", "N/A")

    get!(results_array, "description", "N/A")
    get!(results_array, "sic_code", "N/A")
    get!(results_array, "sic_description", "N/A")
    get!(results_array, "ticker_root", "N/A")
    get!(results_array, "homepage_url", "N/A")
    get!(results_array, "total_employees", NaN)
    get!(results_array, "list_date", "N/A")

    # get if no values - branding dictionary
    get!(results_array, "branding", Dict("logo_url" => "N/A",  "icon_url" => "N/A"))
    get!(results_array["branding"], "logo_url", "N/A")
    get!(results_array["branding"], "icon_url", "N/A")

    get!(results_array, "share_class_shares_outstanding", NaN)
    get!(results_array, "share_class_shares_outstanding", NaN)
    get!(results_array, "delisted_utc", "N/A")

    # build results tuple -
    result_tuple = (

            ticker = results_array["ticker"],
            name = results_array["name"],
            market = results_array["market"],
            locale = results_array["locale"],
            primary_exchange = results_array["primary_exchange"],
            type = results_array["type"],
            active = results_array["active"],
            currency_name = results_array["currency_name"],
            cik = results_array["cik"],
            composite_figi = results_array["composite_figi"],
            share_class_figi = results_array["share_class_figi"],
            market_cap = results_array["market_cap"],
            phone_number = results_array["phone_number"],
            address1 = results_array["address"]["address1"],
            city = results_array["address"]["city"],
            state = results_array["address"]["state"],
            postal_code = results_array["address"]["postal_code"],
            description = results_array["description"],
            sic_code = results_array["sic_code"],
            sic_description = results_array["sic_description"],
            ticker_root = results_array["ticker_root"],
            homepage_url = results_array["homepage_url"],
            total_employees = results_array["total_employees"],
            list_date = results_array["list_date"],
            logo_url = results_array["branding"]["logo_url"],
            icon_url = results_array["branding"]["icon_url"],        
            share_class_shares_outstanding = results_array["share_class_shares_outstanding"],
            weighted_shares_outstanding = results_array["weighted_shares_outstanding"],
            delisted_utc = results_array["delisted_utc"]
    );
    
    # grab and push into the dataframe -
    push!(df, result_tuple)

    # return -
    return (header_dictionary, df)
end

function _process_market_holidays_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    
    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        exchange = String[],
        name = String[],
        date = Date[],
        status = String[],
        open = String[],
        close = String[]
    );
    
    # populate the results DataFrame -
    results_array = request_body_dictionary
    for result_dictionary ∈ results_array
        
        get!(result_dictionary, "open", "N/A")
        get!(result_dictionary, "close", "N/A")
        
        # build a results tuple -
        result_tuple = (

            exchange = result_dictionary["exchange"],
            name = result_dictionary["name"],
            date = Date(result_dictionary["date"]),
            status = result_dictionary["status"],
            open = result_dictionary["open"],
            close = result_dictionary["close"]
        );
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_exchanges_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end
    
    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        id = Int[],
        type = String[],
        asset_class = String[],
        locale = String[],
        name = String[],
        acronym = String[],
        mic = String[],
        operating_mic = String[],
        participant_id = String[],
        url = String[]

    );
    
    # fill in the header dictionary -
    header_keys = [
        "status", "request_id", "count"
    ];
    
    # check - do we have a count (if not resturn zero)
    results_count = get!(request_body_dictionary, "count", 0)
    
    # if no result we return nothing
    if (results_count == 0) # we have no results ...
        
        # return the header and nothing -
        return (header_dictionary, nothing)
    end
    
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        
        # set some defaults in case of missing fields -
        get!(result_dictionary, "acronym", "N/A")
        get!(result_dictionary, "mic", "N/A")
        get!(result_dictionary, "operating_mic", "N/A")
        get!(result_dictionary, "participant_id", "N/A")
        get!(result_dictionary, "url", "N/A")

        result_tuple = (

            id = result_dictionary["id"],
            type = result_dictionary["type"],
            asset_class = result_dictionary["asset_class"],
            locale = result_dictionary["locale"],
            name = result_dictionary["name"],
            acronym = result_dictionary["acronym"],
            mic = result_dictionary["mic"],
            operating_mic = result_dictionary["operating_mic"],
            participant_id = result_dictionary["participant_id"],
            url = result_dictionary["url"]
        );

        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_stock_splits_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        execution_date = Date[],
        split_from = Int[],
        split_to = Int[],
        ticker = String[]
    );
    
    # fill in the header dictionary -
    header_keys = [
        "status", "request_id"
    ];
    
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # if no result we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        result_tuple = (

            execution_date = Date(result_dictionary["execution_date"]),
            split_from = result_dictionary["split_from"],
            split_to = result_dictionary["split_to"],
            ticker = result_dictionary["ticker"] 
        )

        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_market_status_call_response(body::String) # ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    #initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(
        
        serverTime = String[],
        market = String[],
        earlyHours = Bool[],
        afterHours = Bool[],
        nyse  = String[],
        nasdaq  = String[],
        otc = String[],
        fx  = String[],
        crypto  = String[]
    );

    # populate the results DataFrame -
    results_array = request_body_dictionary
    
    # build a results tuple -
    result_tuple = (
        
        serverTime = results_array["serverTime"],    
        market = results_array["market"],
        earlyHours = results_array["earlyHours"],
        afterHours = results_array["afterHours"],
        nyse = results_array["exchanges"]["nyse"],
        nasdaq = results_array["exchanges"]["nasdaq"],
        otc = results_array["exchanges"]["otc"],        
        fx = results_array["currencies"]["fx"],
        crypto = results_array["currencies"]["crypto"]
    );
    
    # push that tuple into the df -
    push!(df, result_tuple)
    
    # return -
    return (header_dictionary, df)
end

function _process_dividends_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "NOT_FOUND" || status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    #initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

            cash_amount = Float64[],
            declaration_date = Date[],
            dividend_type = String[],
            ex_dividend_date = Date[],
            frequency = Int[],
            pay_date = Date[],
            record_date = Date[],
            ticker =String[]
        )

    # fill in the header dictionary -
    header_keys = [
        "status", "request_id","next_url"
    ];

    #fill in next_url if no value
    get!(request_body_dictionary,"next_url", "N/A")

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end
    
    # if no results we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end


    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        result_tuple = (

                    cash_amount = result_dictionary["cash_amount"],
                    declaration_date = Date(result_dictionary["declaration_date"]),
                    dividend_type = result_dictionary["dividend_type"],
                    ex_dividend_date = Date(result_dictionary["ex_dividend_date"]),
                    frequency = result_dictionary["frequency"],
                    pay_date = Date(result_dictionary["pay_date"]),
                    record_date = Date(result_dictionary["record_date"]),
                    ticker = result_dictionary["ticker"],

                )

        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_tickers_call_response(body::String) #ycpan
    
    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        ticker = String[],
        name = String[],
        market = String[],
        locale = String[],
        active = Bool[],
        primary_exchange = String[],
        type = String[],
        currency_name = String[],
        cik = String[],
        composite_figi = String[],
        share_class_figi = String[],
        last_updated_utc = String[],
        delisted_utc = String[]

        )

    # fill in the header dictionary -
    header_keys = [
        "status", "request_id", "count", "next_url"
    ];

    # fill in next_url if no value
    get!(request_body_dictionary,"next_url", "N/A")
    get!(request_body_dictionary,"count", 0)

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # if no results we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        #get if no values
        get!(result_dictionary, "primary_exchange", "N/A")
        get!(result_dictionary, "type", "N/A")
        get!(result_dictionary, "currency_name", "N/A")
        get!(result_dictionary, "cik", "N/A")
        get!(result_dictionary, "composite_figi", "N/A")
        get!(result_dictionary, "share_class_figi", "N/A")
        get!(result_dictionary, "last_updated_utc", "N/A")
        get!(result_dictionary, "delisted_utc", "N/A")

        result_tuple = (

                    ticker = result_dictionary["ticker"],
                    name = result_dictionary["name"],
                    market = result_dictionary["market"],
                    locale = result_dictionary["locale"],
                    active = result_dictionary["active"],
                    primary_exchange = result_dictionary["primary_exchange"],
                    type = result_dictionary["type"],
                    currency_name = result_dictionary["currency_name"],
                    cik = result_dictionary["cik"],
                    composite_figi = result_dictionary["composite_figi"],
                    share_class_figi = result_dictionary["share_class_figi"],
                    last_updated_utc = result_dictionary["last_updated_utc"],
                    delisted_utc = result_dictionary["delisted_utc"]
                )

        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_conditions_call_response(body::String) #ycpan
    
    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(
    
        name = String[],#
        asset_class = String[],#
        data_types =  Array{Array{String,1},1}(),#
        id = Int[],#
        abbreviation = String[],
        description = String[],
        exchange = String[],
        legacy = String[],
        sip_mapping_CTA = String[],
        sip_mapping_OPRA = String[],
        sip_mapping_UTP = String[],
        type = String[],#
        consolidated_updates_high_low = String[],
        consolidated_updates_open_close = String[],
        consolidated_updates_volume = String[],
        market_center_updates_high_low = String[],
        market_center_updates_open_close = String[],
        market_center_updates_volume = String[]

    );

    # fill in the header dictionary -
    header_keys = [
        "status", "request_id", "count", "next_url"
    ];

    #fill in next_url if no value
    get!(request_body_dictionary,"next_url","N/A")
    get!(request_body_dictionary,"count",0)

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # if no results we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        #get if no values
        get!(result_dictionary, "abbreviation", "N/A")
        get!(result_dictionary, "description", "N/A")
        get!(result_dictionary, "exchange", "N/A")
        get!(result_dictionary, "legacy", "N/A")
        get!(result_dictionary["sip_mapping"], "CTA", "N/A")
        get!(result_dictionary["sip_mapping"], "OPRA", "N/A")
        get!(result_dictionary["sip_mapping"], "UTP", "N/A")
        get!(result_dictionary, "update_rules", Dict("consolidated"  => Dict("updates_high_low"   => "N/A",
                                                                             "updates_open_close" => "N/A", 
                                                                             "updates_volume"     => "N/A"), 
                                                     "market_center" => Dict("updates_high_low"   => "N/A",
                                                                             "updates_open_close" => "N/A",
                                                                             "updates_volume"     => "N/A")))
        result_tuple = (
        
                    name = result_dictionary["name"],
                    asset_class = result_dictionary["asset_class"],
                    data_types = result_dictionary["data_types"],
                    id = result_dictionary["id"],
                    abbreviation = result_dictionary["abbreviation"],
                    description = result_dictionary["description"],
                    exchange = string(result_dictionary["exchange"]),
                    legacy = string(result_dictionary["legacy"]),                    
                    sip_mapping_CTA = result_dictionary["sip_mapping"]["CTA"],
                    sip_mapping_OPRA = result_dictionary["sip_mapping"]["OPRA"],
                    sip_mapping_UTP = result_dictionary["sip_mapping"]["UTP"],
                    type = result_dictionary["type"],                
                    consolidated_updates_high_low = string(result_dictionary["update_rules"]["consolidated"]["updates_high_low"]),
                    consolidated_updates_open_close = string(result_dictionary["update_rules"]["consolidated"]["updates_open_close"]),
                    consolidated_updates_volume = string(result_dictionary["update_rules"]["consolidated"]["updates_volume"]),
                    market_center_updates_high_low = string(result_dictionary["update_rules"]["market_center"]["updates_high_low"]),
                    market_center_updates_open_close = string(result_dictionary["update_rules"]["market_center"]["updates_open_close"]),
                    market_center_updates_volume = string(result_dictionary["update_rules"]["market_center"]["updates_volume"])
                
                )

        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end

function _process_stock_financials_call_response(body::String) #ycpan
    
    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String, Any}()
    df = DataFrame(

        financials = String[],
        content = String[],
        label = String[], 
        order = Int[],
        unit = String[],
        value = Float64[],
        formula = String[],
        xpath = String[]
        )

    # fill in the header dictionary -
    header_keys = [
                "status", "request_id", "count", "next_url"
        ];

    #addressing missing value in header dictionary -
    get!(request_body_dictionary,"next_url","N/A")
    get!(request_body_dictionary,"count",0)

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # if no results we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end


    #pull out financials dictionary
    results_array = request_body_dictionary["results"]
    financials_dictionary = Dict{String, Any}()
    
    for result_dictionary ∈ results_array

        #addressing missing values
        get!(result_dictionary, "start_date", "N/A")
        get!(result_dictionary, "end_date", "N/A")

        #update header dictionary
        header_dictionary["company_name"] = result_dictionary["company_name"]
        header_dictionary["cik"] = result_dictionary["cik"]
        header_dictionary["fiscal_period"] = result_dictionary["fiscal_period"]
        header_dictionary["fiscal_year"] = result_dictionary["fiscal_year"]
        header_dictionary["source_filing_file_url"] = result_dictionary["source_filing_file_url"]
        header_dictionary["source_filing_url"] = result_dictionary["source_filing_url"]
        header_dictionary["start_date"] = result_dictionary["start_date"]
        header_dictionary["end_date"] = result_dictionary["end_date"]

        #pull out financials dictionary
        financials_dictionary =  result_dictionary["financials"]   

    end

    #filling dataframe with desired information
    for i in keys(financials_dictionary)
        for j in keys(financials_dictionary[i])

            #addressing missing values
            get!(financials_dictionary[i][j], "formula", "N/A")
            get!(financials_dictionary[i][j], "xpath", "N/A")
            result_tuple = (

                financials = i,
                content = j,
                label = financials_dictionary[i][j]["label"],
                order = financials_dictionary[i][j]["order"],
                unit = financials_dictionary[i][j]["unit"],
                value = financials_dictionary[i][j]["value"],
                formula = financials_dictionary[i][j]["formula"],
                xpath = financials_dictionary[i][j]["xpath"]
            )
            push!(df, result_tuple)
        end
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_ticker_types_call_response(body::String) #ycpan
    
    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        code = String[],
        description = String[],
        asset_class = String[],
        locale = String[]
    )

    # fill in the header dictionary -
    header_keys = [
                "status", "request_id", "count"
        ];

    #fill in next_url if no value
    get!(request_body_dictionary,"count",0)

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # if no results we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        result_tuple = (

                    code = result_dictionary["code"],
                    description = result_dictionary["description"],
                    asset_class = result_dictionary["asset_class"],
                    locale = result_dictionary["locale"]
                )

        push!(df, result_tuple)
    end

    # return - 
    return (header_dictionary, df)
end

function _process_ti_sma_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # check: do we have a next_url?
    # if not, add an empty value
    get!(request_body_dictionary, "next_url", "")    

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check: if results is empty, then return Nothing in data -
    results_dictionary = request_body_dictionary["results"]
    if (isempty(results_dictionary) == true)
        return _polygon_error_handler(request_body_dictionary)
    end
    
    # we have results, build a data frame and package up -
    # process values first -
    sma_data_array = results_dictionary["values"];

    df_sma = DataFrame(
        timestamp = DateTime[],
        value = Float64[]
    );
    for data_dictionary ∈ sma_data_array
        
        # build the results tuple -
        results_tuple = (
            timestamp = unix2datetime(data_dictionary["timestamp"]*(1/1000)),
            value = data_dictionary["value"]
        );
    
        # push -
        push!(df_sma, results_tuple)
    end

    # ok, so if we have no underlying, then we can exit -
    if (haskey(results_dictionary, "underlying") == false)
        return (header_dictionary, df_sma, nothing)
    end

    # ok, so if we get get here, then we have extra data. 
    # Need to build a data from to hold it -
    df_underlying = DataFrame(
        c = Float64[],
        h = Float64[],
        l = Float64[],
        n = Int[],
        o = Float64[],
        t = DateTime[],
        v = Int64[],
        vw = Float64[]
    );

    # get aggregates data -
    aggregates_data_array = results_dictionary["underlying"]["aggregates"]
    for data_dictionary ∈ aggregates_data_array
        
        # build the results tuple -
        results_tuple = (
            c = data_dictionary["c"],
            h = data_dictionary["h"],
            l = data_dictionary["l"],
            n = data_dictionary["n"],
            o = data_dictionary["o"],
            t = unix2datetime(data_dictionary["t"]*(1/1000)),
            v = data_dictionary["v"],
            vw = data_dictionary["vw"]
        );
    
        # grab these results -
        push!(df_underlying, results_tuple)
    end

    # ok, so we have *two* data frames and a header -
    return (header_dictionary, df_sma, df_underlying);
end

function _process_ti_ema_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # check: do we have a next_url?
    # if not, add an empty value
    get!(request_body_dictionary, "next_url", "")    

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check: if results is empty, then return Nothing in data -
    results_dictionary = request_body_dictionary["results"]
    if (isempty(results_dictionary) == true)
        return _polygon_error_handler(request_body_dictionary)
    end
    
    # we have results, build a data frame and package up -
    # process values first -
    sma_data_array = results_dictionary["values"];
    df_ema = DataFrame(
        timestamp = DateTime[],
        value = Float64[]
    );
    for data_dictionary ∈ sma_data_array
        
        # build the results tuple -
        results_tuple = (
            timestamp = unix2datetime(data_dictionary["timestamp"]*(1/1000)),
            value = data_dictionary["value"]
        );
    
        # push -
        push!(df_ema, results_tuple)
    end

    # ok, so if we have no underlying, then we can exit -
    if (haskey(results_dictionary, "underlying") == false)
        return (header_dictionary, df_ema, nothing)
    end

    # ok, so if we get get here, then we have extra data. 
    # Need to build a data from to hold it -
    df_underlying = DataFrame(
        T = String[],
        c = Float64[],
        h = Float64[],
        l = Float64[],
        n = Int[],
        o = Float64[],
        t = DateTime[],
        v = Int64[],
        vw = Float64[]
    );

    # get aggregates data -
    aggregates_data_array = results_dictionary["underlying"]["aggregates"]
    for data_dictionary ∈ aggregates_data_array
        
        # build the results tuple -
        results_tuple = (
            T = data_dictionary["T"],
            c = data_dictionary["c"],
            h = data_dictionary["h"],
            l = data_dictionary["l"],
            n = data_dictionary["n"],
            o = data_dictionary["o"],
            t = unix2datetime(data_dictionary["t"]*(1/1000)),
            v = data_dictionary["v"],
            vw = data_dictionary["vw"]
        );
    
        # grab these results -
        push!(df_underlying, results_tuple)
    end

    # ok, so we have *two* data frames and a header -
    return (header_dictionary, df_ema, df_underlying);
end

function _process_ti_macd_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # check: do we have a next_url?
    # if not, add an empty value
    get!(request_body_dictionary, "next_url", "")    

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check: if results is empty, then return Nothing in data -
    results_dictionary = request_body_dictionary["results"]
    if (isempty(results_dictionary) == true)
        return _polygon_error_handler(request_body_dictionary)
    end

    # we have results, build a data frame and package up -
    # do we have any values?
    if (haskey(results_dictionary,"values") == false)
        return (header_dictionary, nothing, nothing)
    end

    # process values first -`
    macd_data_array = results_dictionary["values"];
    df_macd = DataFrame(
        timestamp = DateTime[],
        signal = Float64[],
        histogram = Float64[],
        value = Float64[]
    );
    for data_dictionary ∈  macd_data_array
        
        # build the results tuple -
        results_tuple = (
            timestamp = unix2datetime(data_dictionary["timestamp"]*(1/1000)),
            value = data_dictionary["value"],
            signal = data_dictionary["signal"],
            histogram = data_dictionary["histogram"]
        );
    
        # push -
        push!(df_macd, results_tuple)
    end

     # ok, so if we have no underlying, then we can exit -
     if (haskey(results_dictionary, "underlying") == false)
        return (header_dictionary, df_ema, nothing)
    end

    # ok, so if we get get here, then we have extra data. 
    # Need to build a data from to hold it -
    df_underlying = DataFrame(
        T = String[],
        c = Float64[],
        h = Float64[],
        l = Float64[],
        n = Int[],
        o = Float64[],
        t = DateTime[],
        v = Int64[],
        vw = Float64[]
    );

    # get aggregates data -
    aggregates_data_array = results_dictionary["underlying"]["aggregates"]
    for data_dictionary ∈ aggregates_data_array
        
        # build the results tuple -
        results_tuple = (
            T = data_dictionary["T"],
            c = data_dictionary["c"],
            h = data_dictionary["h"],
            l = data_dictionary["l"],
            n = data_dictionary["n"],
            o = data_dictionary["o"],
            t = unix2datetime(data_dictionary["t"]*(1/1000)),
            v = data_dictionary["v"],
            vw = data_dictionary["vw"]
        );
    
        # grab these results -
        push!(df_underlying, results_tuple)
    end

    # ok, so we have *two* data frames and a header -
    return (header_dictionary, df_macd, df_underlying);
end

function _process_ti_rsi_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # check: do we have a next_url?
    # if not, add an empty value
    get!(request_body_dictionary, "next_url", "")    

    # build the header dictionary -
    header_dictionary = Dict{String,Any}()
    header_keys = [
        "status", "request_id", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check: if results is empty, then return Nothing in data -
    results_dictionary = request_body_dictionary["results"]
    if (isempty(results_dictionary) == true)
        return _polygon_error_handler(request_body_dictionary)
    end
    
    # we have results, build a data frame and package up -
    # process values first -
    rsi_data_array = results_dictionary["values"];

    df_rsi = DataFrame(
        timestamp = DateTime[],
        value = Float64[]
    );
    for data_dictionary ∈ rsi_data_array
        
        # build the results tuple -
        results_tuple = (
            timestamp = unix2datetime(data_dictionary["timestamp"]*(1/1000)),
            value = data_dictionary["value"]
        );
    
        # push -
        push!(df_rsi, results_tuple)
    end

    # ok, so if we have no underlying, then we can exit -
    if (haskey(results_dictionary, "underlying") == false)
        return (header_dictionary, df_rsi, nothing)
    end

    # ok, so if we get get here, then we have extra data. 
    # Need to build a data from to hold it -
    df_underlying = DataFrame(
        c = Float64[],
        h = Float64[],
        l = Float64[],
        n = Int[],
        o = Float64[],
        t = DateTime[],
        v = Int64[],
        vw = Float64[]
    );

    # get aggregates data -
    aggregates_data_array = results_dictionary["underlying"]["aggregates"]
    for data_dictionary ∈ aggregates_data_array
        
        # build the results tuple -
        results_tuple = (
            c = data_dictionary["c"],
            h = data_dictionary["h"],
            l = data_dictionary["l"],
            n = data_dictionary["n"],
            o = data_dictionary["o"],
            t = unix2datetime(data_dictionary["t"]*(1/1000)),
            v = data_dictionary["v"],
            vw = data_dictionary["vw"]
        );
    
        # grab these results -
        push!(df_underlying, results_tuple)
    end

    # ok, so we have *two* data frames and a header -
    return (header_dictionary, df_rsi, df_underlying);
end
# =================================================================================== #