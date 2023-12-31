#' Appsheet Function
#'
#' This function interacts with the AppSheet API to perform actions on a specified table. 
#' For more info, check the [official documentation](https://support.google.com/appsheet/answer/10105768).
#'
#' @inheritParams ash_request
#'
#' @return A data frame containing the response from the AppSheet API.
#' 
#' @export
#' 
#' @importFrom magrittr %>%
#' 
#' @examples
#' \dontrun{
#' appsheet("my_table")
#' appsheet("my_table", Properties = ash_properties(Locale = "en-GB"))
#' }
#'
appsheet <- function(
		tableName,
		Action = "Find", 
		Properties = ash_properties(), 
		Rows = list(),
		appId = Sys.getenv("APPSHEET_APP_ID"),
		access_key = Sys.getenv("APPSHEET_APP_ACCESS_KEY")
) {
	request <- ash_request(
			tableName = tableName,
			Action = Action,
			Properties = Properties,
			Rows = Rows,
			appId = appId,
			access_key = access_key
		)
	
	response <- request %>% 
		httr2::req_perform() %>% 
		httr2::resp_body_json() 
	
	# When Action != "Find" the response content is wrapped 
	# inside the Rows property. really annoying
	if ("Rows" %in% names(response)) {
		response <- response$Rows
	}
	
	response %>%
		purrr::map(~ purrr::discard(.x, is.null)) %>% # discards NULL columns from appsheet DB
		purrr::map(tibble::as_tibble) %>% 
		purrr::list_rbind()
}

# This one exists here to be loaded for unit testing
appsheet_alt <- function(...) {
	appsheet(
		...,
		appId = Sys.getenv("APPSHEET_APP_ID_ALT"),
		access_key = Sys.getenv("APPSHEET_APP_ACCESS_KEY_ALT")
	)
}
