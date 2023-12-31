test_that("Action Add and Delete work", {
	skip_on_cran()
	# We test these together to take advantage of parallel testing 
	# without adding infinte rows per check()
	
	# This complicated row_key is meant to prevent key collisions 
	# when performing multiple github actions
	row_key <- sample(letters, size = 8, replace = TRUE) %>% paste0(collapse = "")
	
	row_to_add <- structure(
		.Data = list(
			Key = row_key,
			Email = "driver999@company.com"
		),
		row.names = c(NA,-1L),
		class = c("tbl_df", "tbl", "data.frame")
	)
	
	appsheet(tableName = "Driver", Action = "Add", Rows = row_to_add) %>%
		expect_s3_class(class = "data.frame")
	
	row_to_delete <- structure(
		.Data = list(Key = row_key),
		row.names = c(NA,-1L),
		class = c("tbl_df", "tbl", "data.frame")
	)
	
	appsheet(tableName = "Driver", Action = "Delete", Rows = row_to_delete) %>%
		expect_s3_class(class = "data.frame")
})

test_that("Action Add and Delete work in appsheet database", {
	skip_on_cran()
	# We test these together to take advantage of parallel testing 
	# without adding infinte rows per check()
	
	# Here we don't use a custom key because the database returns a Row ID
	
	row_to_add <- tibble::tibble(Title = "Item 99")
	
	row_added <- appsheet_alt(tableName = "items", Action = "Add", Rows = row_to_add) %>%
		expect_s3_class(class = "data.frame")
	
	# We can just pass the row_added to the delete action and it works
	appsheet_alt(tableName = "items", Action = "Delete", Rows = row_added) %>%
		expect_s3_class(class = "data.frame")
})
