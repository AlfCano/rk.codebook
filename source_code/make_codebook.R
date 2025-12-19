local({
  # =========================================================================================
  # 1. Package Definition and Metadata
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.10-3")

  package_about <- rk.XML.about(
    name = "rk.codebook",
    author = person(
      given = "Alfonso",
      family = "Cano",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "An RKWard plugin for generating data dictionaries (codebooks) using 'sjPlot'. Integrates RKWard variable labels into standard HTML reports.",
      version = "0.0.1", # FROZEN
      url = "https://github.com/AlfCano/rk.codebook",
      license = "GPL (>= 3)"
    )
  )

  # Menu Hierarchy
  common_hierarchy <- list("analysis", "Data Documentation (codebook)")

  # =========================================================================================
  # COMPONENT 1: Generate Codebook (MAIN PLUGIN)
  # =========================================================================================

  help_codebook <- rk.rkh.doc(
    title = rk.rkh.title(text = "Generate Data Codebook"),
    summary = rk.rkh.summary(text = "Creates a comprehensive HTML data dictionary summarizing variable names, labels, values, missing data percentages, and distributions."),
    usage = rk.rkh.usage(text = "Select a dataframe. Configure which statistics to show. The result is printed to the Output window.")
  )

  cb_selector <- rk.XML.varselector(id.name = "cb_selector")

  cb_df <- rk.XML.varslot(label = "Dataframe", source = "cb_selector", classes = "data.frame", required = TRUE, id.name = "cb_df")

  # Sync Option
  cb_sync <- rk.XML.cbox(label = "Sync RKWard Variable Labels to Report", value = "1", chk = TRUE, id.name = "cb_sync")

  # Content Options
  cb_show_type <- rk.XML.cbox(label = "Show Variable Type", value = "1", chk = TRUE, id.name = "show_type")
  cb_show_values <- rk.XML.cbox(label = "Show Values", value = "1", chk = TRUE, id.name = "show_values")
  cb_show_labels <- rk.XML.cbox(label = "Show Value Labels", value = "1", chk = TRUE, id.name = "show_labels")
  cb_show_frq <- rk.XML.cbox(label = "Show Frequencies", value = "1", chk = TRUE, id.name = "show_frq")
  cb_show_prc <- rk.XML.cbox(label = "Show Percentages", value = "1", chk = TRUE, id.name = "show_prc")
  cb_show_na <- rk.XML.cbox(label = "Show Missing Values (NA)", value = "1", chk = TRUE, id.name = "show_na")

  cb_max_len <- rk.XML.spinbox(label = "Max Label Length (chars)", min = 10, max = 500, initial = 50, id.name = "max_len")

  cb_save <- rk.XML.saveobj(label = "Save HTML object as", chk = FALSE, initial = "codebook_html", id.name = "cb_save_obj")

  # Preview mode "output" is correct, but we must write to the file manually in JS
  cb_preview <- rk.XML.preview(mode = "output", id.name = "codebook_preview")

  dialog_codebook <- rk.XML.dialog(
    label = "Generate Data Codebook",
    child = rk.XML.row(
        cb_selector,
        rk.XML.col(
            cb_df,
            rk.XML.frame(cb_sync, label = "Metadata Integration"),
            rk.XML.frame(
                cb_show_type, cb_show_values, cb_show_labels,
                cb_show_frq, cb_show_prc, cb_show_na,
                label = "Table Content"
            ),
            rk.XML.frame(cb_max_len, label = "Formatting"),
            cb_save,
            cb_preview
        )
    )
  )

  # JS Logic
  js_body_codebook <- '
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
            cmd_prep += "df_temp <- " + df + "\\n";
            cmd_prep += "for (col in names(df_temp)) {\\n";
            cmd_prep += "   lbl <- rk.get.label(df_temp[[col]])\\n";
            cmd_prep += "   if (!is.null(lbl) && lbl != \\"\\") attr(df_temp[[col]], \\"label\\") <- lbl\\n";
            cmd_prep += "}\\n";
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
  '

  js_calc_codebook <- paste0(js_body_codebook, '
    if (df != "") {
        echo(cmd_prep);
        echo("codebook_html <- " + cmd_plot + "\\n");
    }
  ')

  # PRINT: Write raw HTML to the output file manually
  js_print_codebook <- paste0(js_body_codebook, '
    if (df != "") {
        echo("rk.header(\\"Data Codebook: " + df + "\\", level=3);\\n");
        // Inject RAW HTML directly into the RKWard output file
        echo("cat(codebook_html$knitr, file = rk.get.output.html.file(), append = TRUE)\\n");
        if (sync == "1") echo("rm(df_temp)\\n");
    }
  ')

  # PREVIEW: Same technique - write raw HTML to the active output file (which is the preview file in this mode)
  js_preview_codebook <- paste0(js_body_codebook, '
    if (df != "") {
        echo("suppressPackageStartupMessages(require(sjPlot))\\n");
        echo(cmd_prep);
        echo("temp_res <- " + cmd_plot + "\\n");
        // Inject RAW HTML directly into the Preview file
        echo("cat(temp_res$knitr, file = rk.get.output.html.file(), append = TRUE)\\n");
        if (sync == "1") echo("rm(df_temp)\\n");
    }
  ')

  # NOTE: Component defined but NOT added to list (it is the Main Plugin)
  component_codebook <- rk.plugin.component(
    "GenerateCodebook",
    xml = list(dialog = dialog_codebook),
    js = list(require="sjPlot", calculate = js_calc_codebook, preview = js_preview_codebook, printout = js_print_codebook),
    hierarchy = common_hierarchy,
    rkh = list(help = help_codebook)
  )

  # =========================================================================================
  # BUILD SKELETON
  # =========================================================================================

  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = dialog_codebook),
    js = list(
        require = "sjPlot",
        calculate = js_calc_codebook,
        printout = js_print_codebook,
        preview = js_preview_codebook
    ),
    rkh = list(help = help_codebook),
    components = list(),
    pluginmap = list(
        name = "Generate Codebook",
        hierarchy = common_hierarchy
    ),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\nPlugin package 'rk.codebook' (v0.0.1) generated successfully with Raw HTML Injection.\n")
  cat("  1. rk.updatePluginMessages(path=\".\")\n")
  cat("  2. devtools::install(\".\")\n")
})
