// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!

function preview(){
	
    var df = getValue("cb_df");
    var sync = getValue("cb_sync");
    var s_type = (getValue("show_type") == "1") ? "TRUE" : "FALSE";
    var s_val = (getValue("show_values") == "1") ? "TRUE" : "FALSE";
    var s_lbl = (getValue("show_labels") == "1") ? "TRUE" : "FALSE";
    var s_frq = (getValue("show_frq") == "1") ? "TRUE" : "FALSE";
    var s_prc = (getValue("show_prc") == "1") ? "TRUE" : "FALSE";
    var s_na = (getValue("show_na") == "1") ? "TRUE" : "FALSE";
    var len = getValue("max_len");
    
    var cmd_prep = "";
    var target_df = df;
    
    if (df != "") {
        // Metadata Sync Logic
        if (sync == "1") {
            target_df = "df_temp"; 
            cmd_prep += "df_temp <- " + df + "\n";
            cmd_prep += "for (col in names(df_temp)) {\n";
            cmd_prep += "   lbl <- rk.get.label(df_temp[[col]])\n";
            cmd_prep += "   if (!is.null(lbl) && lbl != \"\") attr(df_temp[[col]], \"label\") <- lbl\n";
            cmd_prep += "}\n";
        }
        
        // sjPlot::view_df call (No Title argument)
        var cmd_plot = "sjPlot::view_df(" + target_df + ", " +
                       "show.type = " + s_type + ", " +
                       "show.values = " + s_val + ", " +
                       "show.labels = " + s_lbl + ", " +
                       "show.frq = " + s_frq + ", " +
                       "show.prc = " + s_prc + ", " +
                       "show.na = " + s_na + ", " +
                       "max.len = " + len + ", " +
                       "show.string.values = TRUE)";
    }
  
    if (df != "") {
        echo("suppressPackageStartupMessages(require(sjPlot))\n");
        echo(cmd_prep);
        echo("temp_res <- " + cmd_plot + "\n");
        // Inject RAW HTML directly into the Preview file
        echo("cat(temp_res$knitr, file = rk.get.output.html.file(), append = TRUE)\n");
        if (sync == "1") echo("rm(df_temp)\n");
    }
  
}

function preprocess(is_preview){
	// add requirements etc. here
	if(is_preview) {
		echo("if(!base::require(sjPlot)){stop(" + i18n("Preview not available, because package sjPlot is not installed or cannot be loaded.") + ")}\n");
	} else {
		echo("require(sjPlot)\n");
	}
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var df = getValue("cb_df");
    var sync = getValue("cb_sync");
    var s_type = (getValue("show_type") == "1") ? "TRUE" : "FALSE";
    var s_val = (getValue("show_values") == "1") ? "TRUE" : "FALSE";
    var s_lbl = (getValue("show_labels") == "1") ? "TRUE" : "FALSE";
    var s_frq = (getValue("show_frq") == "1") ? "TRUE" : "FALSE";
    var s_prc = (getValue("show_prc") == "1") ? "TRUE" : "FALSE";
    var s_na = (getValue("show_na") == "1") ? "TRUE" : "FALSE";
    var len = getValue("max_len");
    
    var cmd_prep = "";
    var target_df = df;
    
    if (df != "") {
        // Metadata Sync Logic
        if (sync == "1") {
            target_df = "df_temp"; 
            cmd_prep += "df_temp <- " + df + "\n";
            cmd_prep += "for (col in names(df_temp)) {\n";
            cmd_prep += "   lbl <- rk.get.label(df_temp[[col]])\n";
            cmd_prep += "   if (!is.null(lbl) && lbl != \"\") attr(df_temp[[col]], \"label\") <- lbl\n";
            cmd_prep += "}\n";
        }
        
        // sjPlot::view_df call (No Title argument)
        var cmd_plot = "sjPlot::view_df(" + target_df + ", " +
                       "show.type = " + s_type + ", " +
                       "show.values = " + s_val + ", " +
                       "show.labels = " + s_lbl + ", " +
                       "show.frq = " + s_frq + ", " +
                       "show.prc = " + s_prc + ", " +
                       "show.na = " + s_na + ", " +
                       "max.len = " + len + ", " +
                       "show.string.values = TRUE)";
    }
  
    if (df != "") {
        echo(cmd_prep);
        echo("codebook_html <- " + cmd_plot + "\n");
    }
  
}

function printout(is_preview){
	// read in variables from dialog


	// printout the results
	if(!is_preview) {
		new Header(i18n("Generate Codebook results")).print();	
	}
    var df = getValue("cb_df");
    var sync = getValue("cb_sync");
    var s_type = (getValue("show_type") == "1") ? "TRUE" : "FALSE";
    var s_val = (getValue("show_values") == "1") ? "TRUE" : "FALSE";
    var s_lbl = (getValue("show_labels") == "1") ? "TRUE" : "FALSE";
    var s_frq = (getValue("show_frq") == "1") ? "TRUE" : "FALSE";
    var s_prc = (getValue("show_prc") == "1") ? "TRUE" : "FALSE";
    var s_na = (getValue("show_na") == "1") ? "TRUE" : "FALSE";
    var len = getValue("max_len");
    
    var cmd_prep = "";
    var target_df = df;
    
    if (df != "") {
        // Metadata Sync Logic
        if (sync == "1") {
            target_df = "df_temp"; 
            cmd_prep += "df_temp <- " + df + "\n";
            cmd_prep += "for (col in names(df_temp)) {\n";
            cmd_prep += "   lbl <- rk.get.label(df_temp[[col]])\n";
            cmd_prep += "   if (!is.null(lbl) && lbl != \"\") attr(df_temp[[col]], \"label\") <- lbl\n";
            cmd_prep += "}\n";
        }
        
        // sjPlot::view_df call (No Title argument)
        var cmd_plot = "sjPlot::view_df(" + target_df + ", " +
                       "show.type = " + s_type + ", " +
                       "show.values = " + s_val + ", " +
                       "show.labels = " + s_lbl + ", " +
                       "show.frq = " + s_frq + ", " +
                       "show.prc = " + s_prc + ", " +
                       "show.na = " + s_na + ", " +
                       "max.len = " + len + ", " +
                       "show.string.values = TRUE)";
    }
  
    if (df != "") {
        echo("rk.header(\"Data Codebook: " + df + "\", level=3);\n");
        // Inject RAW HTML directly into the RKWard output file
        echo("cat(codebook_html$knitr, file = rk.get.output.html.file(), append = TRUE)\n");
        if (sync == "1") echo("rm(df_temp)\n"); 
    }
  
	if(!is_preview) {
		//// save result object
		// read in saveobject variables
		var cbSaveObj = getValue("cb_save_obj");
		var cbSaveObjActive = getValue("cb_save_obj.active");
		var cbSaveObjParent = getValue("cb_save_obj.parent");
		// assign object to chosen environment
		if(cbSaveObjActive) {
			echo(".GlobalEnv$" + cbSaveObj + " <- codebook_html\n");
		}	
	}

}

