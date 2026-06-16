


colors <- c("#e2d5e7", '#bea5cb', '#9270a8')
post_colors <- c("#ddecd6", '#b5d2a4', '#6fac6b')

# Define UI for application 
ui <- navbarPage(
  collapsible=T,
    id = 'main',
      # Combine logo and title in the navbar brand
      title = tags$a(
        href = "#", 
        onclick = "Shiny.setInputValue('go_home', Math.random());",  # trigger event
        style = "text-decoration: none; color: inherit; cursor: pointer;",
        tags$img(
          src = "plato_small.svg",  # Place logo.png in www/ folder
          height = "45px",
          style = "margin-left: 0px; padding-bottom: 15px;"
        ),
        "PLATO",
      ),
    
    
    header = tags$head(
      tags$link(
        rel = "stylesheet",
        href = "https://bootswatch.com/3/yeti/bootstrap.min.css"
      ),
      
      
      tags$style(HTML("
  #footer {
    background-color: #f8f8f8;       /* Yeti navbar background */
    border-top: 1px solid #e7e7e7;   /* Yeti border color */
    color: #777777;                  /* Yeti text */
    padding: 12px 20px;
    padding-bottom: 30px;
    text-align: center;
    margin-top: 40px;
    font-size: 14px;
  }

  #footer a {
    color: #008cba;                  /* Yeti primary blue */
  }

  #footer a:hover {
    color: #005f8c;                  /* darker hover color */
    text-decoration: underline;
  }


  
")),
      
      
    ),
    
    
    

    
    
    
# ---------------------------- CLINICAL RISK SCORE CALC  ---------------------------------------------------------------------------   
    
tags$div(id = "top"),

    tabPanel(value = "home",   # easier to reference than text
      title="Risk calculator",
              div(
                  style = " text-align: center",
                    fluidRow(
                        style = "padding-top: 5px; text-align: center; border: none; box-shadow: none; margin: auto;",
                        h3("PLATO estimates relapse risk after colorectal cancer liver metastasis using published risk scores.", class = "blockquote",
                           style="padding-bottom: 15px;"),
                        tags$hr(style="padding-bottom: 10px;"),
                        
                                column(
                                  style="text-align: left; margin:0px; padding:10px",
                                  class="jumbotron;",
                                  width=12,
                                  fluidRow(
                                  column(
                                    style="text-align: left",
                                    width=12,
                                
                                column(
                                       width=12, 
                                       class = "panel panel-default",
                                       
                                       column(
                                         width =3,
                                         class = "panel panel-default",
                                         style="padding-bottom: 30px;border: none; box-shadow: none;",
                                         h3("Preoperative variables", class="text-light", style="padding-bottom:30px"),
                                         column(width=6,
                                                div(style = "padding: 0px; text-align: left",
                                                    numericInput(
                                                      width = "100%",
                                                      inputId = "MetCount",
                                                      label = "Number of liver metastastases:",
                                                      min=1,
                                                      value = 1,
                                                      step = NA   # allows any free typing
                                                    )),
                                                div(style = "padding: 0px;text-align: left",
                                                    selectizeInput("stage","pT - Primary tumor stage:",
                                                                   width = "100%",
                                                                   choices = c("1","2","3","4", "Unknown"),
                                                                   selected = NULL,
                                                                   options = list(dropdownParent = 'body'))),
                                                
                                                div(style = "padding: 0px; text-align: left",
                                                    selectizeInput("ras","RAS mutations:",
                                                                   width = "100%",
                                                                   choices = list("RAS wild type","NRAS mutation", "KRAS mutation", "NRAS and KRAS mutations", "Unknown"),
                                                                   selected = NULL,
                                                                   options = list(dropdownParent = 'body'))),
                                                div(style = "padding: 0px; text-align: left",
                                                    selectizeInput("DFI_months","Disease-free interval (months):",
                                                                   width = "100%",
                                                                   choices = c("0", "1-11", "12-23", "≥24", "Unknown"),
                                                                   selected = "≥24",
                                                                   options = list(dropdownParent = 'body'))),
                                                div(style = "padding: 0px; text-align: left",
                                                    selectizeInput("ResExtrahepMets", "Extrahepatic metastases:",
                                                                   width = "100%",
                                                                   choices = list("No" = 0, "Yes" = 1, "Unknown" = NA),
                                                                   selected = NULL,
                                                                   options = list(dropdownParent = 'body')))),
                                         column(width=6,
                                                class = "panel panel-default;",
                                                div(style = "padding: 0px; text-align: left",
                                                    numericInput(
                                                      width = "100%",
                                                      inputId = "Size_mm",
                                                      label = "Size of largest metastasis (mm):",
                                                      min=0,
                                                      value = 10,
                                                      step = NA
                                                    )),
                                                
                                                div(style = "padding: 0px; text-align: left",
                                                    selectizeInput("node", "pN - Node-positive primary:",
                                                                   width = "100%",
                                                                   choices = list("No" = 0, "Yes" = 1, "Unknown" = NA),
                                                                   selected = NULL,
                                                                   options = list(dropdownParent = 'body'))),
                                                
                                                
                                                
                                                div(style = "padding: 0px; text-align: left",
                                                    selectizeInput("preop_CEA_ugL","CEA (µg/L):",
                                                                   width = "100%",
                                                                   choices = c("<20", "20-199", "≥200", "Unknown"),
                                                                   selected = NULL,
                                                                   options = list(dropdownParent = 'body'))),
                                                
                                                div(style = "padding: 0px; text-align: left",
                                                    selectizeInput("age_years","Age at diagnosis (years):",
                                                                   width = "100%",
                                                                   choices = c("≤60", ">60","Unknown"),
                                                                   selected = NULL,
                                                                   options = list(dropdownParent = 'body')))
                                                
                                         )),
                                       
                                       column(
                                         width=3,
                                         class = "panel panel-default",
                                         style="padding-bottom: 30px;border: none; box-shadow: none;",
                                         div(
                                           htmlOutput("GAME_score"),
                                           plotOutput("GAME_distPlot", height = "300px", width = "100%"))),
                                       column(
                                         width=3,
                                         class = "panel panel-default",
                                         style="padding-bottom: 30px;border: none; box-shadow: none;",
                                         
                                         div(
                                           htmlOutput("mCS_score"),
                                           plotOutput("mCS_distPlot", height = "300px", width = "100%")
                                   
                                           )),
                                       column(
                                         width=3,
                                         class = "panel panel-default",
                                         style="padding-bottom: 30px;border: none; box-shadow: none;",
                                         div(
                                         htmlOutput("F_score"),
                                         plotOutput("F_distPlot", height = "300px", width = "100%"))),
                                       
                                       conditionalPanel(
                                         condition = "input.show_more % 2 ==1",
                                         column(
                                           width=12,
                                           style='box-shadow: none;',
                                           column(
                                             width=4),
                                           
                                           column(
                                             width=4,
                                             
                                             column(width=12,
                                                    
                                                    htmlOutput("K_score"),
                                                    plotOutput("K_distPlot", height = "300px", width = "100%"))),
                                           column(
                                             width=4,
                                             
                                             column(width=12,
                                                    
                                                    htmlOutput("Na06_score"),
                                                    plotOutput("Na06_distPlot", height = "300px", width = "100%")
                                                    ))
                                         )
                                       ),
                                       
                                       column(
                                         width = 12,
                                         style = "text-align: center;",
                                         actionButton("show_more", "Show More",
                                                      class="btn btn-link btn-lg")
                                         ))), #first row ends
                            
                            # second row starts
                            column(
                              width=12,
                              class = "panel panel-primary;",
                              style="text-align: left;box-shadow: none;",
                                    column(
                                width=12,
                                class = "panel panel-primary",
                                style='box-shadow: none;',
                                column(
                                  width=3, 
                                  h3("Postoperative variables - liver specimen",
                                     style="padding-bottom: 30px; box-shadow: none;border: none;"),
                                  column(width=6,
                                         class = "panel panel-default;",
                                         
                                         div(style = "padding: 0px; text-align: left;",
                                      selectizeInput("Margin_mm","Resection margin (mm):",
                                                     choices = c("<5", "5-9", "≥10", "Unknown"),
                                                     selected = "≥10",
                                                     options = list(dropdownParent = 'body'))),
                                  div(style = "padding: 0px; text-align: left;",
                                      selectizeInput("MaxVitality_p","Maximum tumor viability (%):",
                                                     choices = c("≤30", ">30", "Unknown"),
                                                     selected = NULL,
                                                     options = list(dropdownParent = 'body')))),
                                  column(width=6,
                                         class = "panel panel-default;",
                                  div(style = "padding: 0px; text-align: left;",
                                      selectizeInput("VascInv", "Vascular invasion:",
                                                     choices = list("No" = 0, "Yes" = 1, "Unknown" = NA),
                                                     selected = NULL,
                                                     options = list(dropdownParent = 'body'))),
                                  div(style = "padding: 0px; text-align: left;",
                                      selectizeInput("BiliaryInv","Biliary invasion:",
                                                     choices = list("No" = 0, "Yes" = 1, "Unknown" = NA),
                                                     selected = NULL,
                                                     options = list(dropdownParent = 'body'))))),
                               
                                column(width=1),
                                column(width=3,
                                       htmlOutput("N_score"),
                                       plotOutput("N_distPlot", height = "300px", width = "100%")),
                                column(width=1),
                                column(width=3,
                                       htmlOutput("H_score"),
                                       plotOutput("H_distPlot", height = "300px", width = "100%")),
                                column(width=1),
                                )),
                            
                            
                              
                              
                              )),
                    ),
                  ),
             ),



     

# ------------------------------------------------- EXPLORE RELAPSES  ---------------------------------------------------------  

tabPanel(title = "Explore relapses across risk groups",

         div(
           style = "
                  
                  text-align: center;
                  min-width: 75%;     /* controls readable width */
                  padding: 10px;        /* adds space inside */
                  ",
           fluidRow(
             style = "padding-top: 5px; text-align: center; border: none; box-shadow: none;margin: auto;",
            
             h3("Explore the proportion of observed relapses over time across different risk groups in the study cohort"),
             tags$hr(style="padding-bottom: 10px;"),
             
             column(
               style="text-align: left; margin:0px; padding:10px",
               class="jumbotron",
               width=12,
               
               column(
                 width = 4,
                 
                 
                 column(
                   class = "panel panel-default",
                   width = 12,
                   div(style = "height: 50px;",
                       htmlOutput("GAME_relps_title", inline = FALSE)),
                   div(selectizeInput("ScoreGAME",
                                      "Select the risk group:",
                                      choices = c("Low risk: 0-1", "Moderate risk: 2-3", "High risk: 4-7"),
                                      selected = NULL,
                                      options = list(dropdownParent = 'body'))),
                   
                   div(plotOutput("GAME_relpsPlot",height = "300px", width = "100%"))),
                 
                 column(
                   width = 12,
                   class = "panel panel-default",
                   div(style = "height: 50px;",
                       htmlOutput("Na06_relps_title", inline = FALSE)),
                   div(selectizeInput("ScoreNa06",
                                      "Select the risk group:",
                                      choices = c("Low risk: ≤3", "Moderate risk: 3-5", "High risk: >5"),
                                      selected = NULL,
                                      options = list(dropdownParent = 'body'))),
                   div(plotOutput("Na06_relpsPlot",height = "300px", width = "100%")
                   )),
                 
                 
                 
                 column(
                   class = "panel panel-default",
                   width = 12,
                   div(style = "height: 50px;",
                     htmlOutput("H_relps_title", inline = FALSE)),
                 div(selectizeInput("ScoreH",
                                "Select the risk group:",
                                choices = c("Low risk: 0-2", "Moderate risk: 3-4", "High risk: 5-8"),
                                selected = NULL,
                                options = list(dropdownParent = 'body'))),
                 
                 div(plotOutput("H_relpsPlot",  height = "300px", width = "100%")))),
               
               column(
                 width = 4,
                 
                 column(
                   class = "panel panel-default",
                   width = 12,
                   div(style = "height: 50px;",
                       htmlOutput("F_relps_title", inline = FALSE)),
                   div(selectizeInput("ScoreF",
                                      "Select the risk group:",
                                      choices = c("Low risk: 0-2", "Moderate risk: 3-4", "High risk: 5"),
                                      selected = NULL,
                                      options = list(dropdownParent = 'body'))),
                   
                   div(plotOutput("F_relpsPlot",height = "300px", width = "100%"))),
                 
                 column(
                   class = "panel panel-default",
                   width = 12,
                   div(style = "height: 50px;",
                       htmlOutput("N_relps_title", inline = FALSE)),
                   div(selectizeInput("ScoreN",
                                      "Select the risk group:",
                                      choices = c("Low risk: 0-2", "Moderate risk: 3-4", "High risk: 5-7"),
                                      selected = NULL,
                                      options = list(dropdownParent = 'body'))),
                   div(plotOutput("N_relpsPlot",height = "300px", width = "100%"))
                 )),
               
               column(
                 width = 4,
                 
                 column(
                   class = "panel panel-default",
                   width = 12,
                   div(style = "height: 50px;",
                       htmlOutput("mCS_relps_title", inline = FALSE)),
                   div(selectizeInput("ScoremCS",
                                      "Select the risk group:",
                                      choices = c("Low risk: 0", "Intermediate risk: 1", "Moderate risk: 2", "High risk: 3"),
                                      selected = NULL,
                                      options = list(dropdownParent = 'body'))),
                   div(plotOutput("mCS_relpsPlot",  height = "300px", width = "100%"))),
                 
                 column(
                   class = "panel panel-default",
                   width = 12,
                   div(style = "height: 50px;",
                       htmlOutput("K_relps_title", inline = FALSE)),
                   div(selectizeInput("ScoreK",
                                      "Select the risk group:",
                                      choices = c("Low risk: 1", "Moderate risk: 2", "High risk: 3"),
                                      selected = NULL,
                                      options = list(dropdownParent = 'body'))),
                           
                           div(plotOutput("K_relpsPlot",height = "300px", width = "100%"))
                      ),
  ),
                  ),
                ))),

    




# --------------------------------------REFERENCES ------------------------------

tabPanel(title = "References",
         div(
           style = "
                  
                  text-align: center;
                  min-width: 75%;     /* controls readable width */
                  padding: 10px;        /* adds space inside */
                  ",
                fluidRow(
                  style = "padding-top: 5px; text-align: center; border: none; box-shadow: none;margin: auto;",
                  
                    h2("References for risk scores"),
                    
                    tags$hr(style="padding-bottom: 10px;"),
                  column(
                    width=12,
                    style = "margin:0px; padding:20px",
                    class="jumbotron",
                    
                    div(
                      class = "panel panel-default",
                      style = "
      text-align: left;
      min-width: 75%;     /* controls readable width */
      margin: auto;         /* centers the block horizontally */
      padding: 10px;        /* adds space inside */
    ",
                      id = "refs",
                      tags$ol(
                        style = "border: none; box-shadow: none;padding: 1.5rem; text-align: left",
                        h4(strong("Fong score: "), "Fong, Y., Fortner, J., Sun, R. L., Brennan, M. F., Blumgart, L. H. Clinical Score for Predicting Recurrence After Hepatic Resection for Metastatic Colorectal Cancer: Analysis of 1001 Consecutive Cases. Annals of Surgery 230(3):p 309 (1999). doi: 10.1097/00000658-199909000-00004. PMID:  10493478; PmCSID: PmCS1420876.",
                           tags$a(
                             href = "https://doi.org/10.1097/00000658-199909000-00004",
                             "View the publication",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"),style="padding-bottom: 20px"),
                        h4(strong("GAME score: "), "Margonis, G.A., Sasaki, K., Gholami, S., Kim, Y., Andreatos, N., Rezaee, N., Deshwar, A., Buettner, S., Allen, P.J., Kingham T.P., Pawlik, T.M., He, J., Cameron, J.L., Jarnagin, W.R., Wolfgang, C.L., D'Angelica, M.I., Weiss, M.J. Genetic And Morphological Evaluation (GAME) score for patients with colorectal liver metastases. Br J Surg.  105(9):1210-1220 (2018). doi: 10.1002/bjs.10838. PMID: 29691844; PMCID: PMC7988484.",
                           tags$a(
                             href = "https://doi.org/10.1002/bjs.10838",
                             "View the publication",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"),style="padding-bottom: 20px"),
                        h4(strong('Helsinki score: '), "Reijonen, P., Nordin, A., Savikko, J., Poussa, T., Arola, J. Isoniemi, H. Histopathological Helsinki score of colorectal liver metastases predicts survival after liver resection. APMIS, 131: 249-261 (2023). doi: 10.1111/apm.13305. PMID:  36919871.",
                           tags$a(
                             href = "https://doi.org/10.1111/apm.13305",
                             "View the publication",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"
                           )),
                        h4(strong("Konopke score: "),"Konopke, R., Kersting, S., Distler, M., Dietrich, J., Gastmeier, J., Heller, A., Kulisch, E. and Saeger, H.-D. Prognostic factors and evaluation of a clinical score for predicting survival after resection of colorectal liver metastases. Liver International, 29: 89-102 (2009). doi: 10.1111/j.1478-3231.2008.01845.x. PMID: 18673436.",
                           tags$a(
                             href = "https://doi.org/10.1111/j.1478-3231.2008.01845.x",
                             "View the publication",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"),style="padding-bottom: 20px"),
                        h4(strong("m-CS: "), "Brudvik, K.W., Jones, R.P., Giuliante, F., Shindoh, J., Passot, G., Chung, M.H., Song, J., Li, L., Dagenborg, V.J., Fretland, Å.A., Røsok, B., De Rose, A.M., Ardito, F., Edwin, B., Panettieri, E., Larocca, L.M., Yamashita, S., Conrad, C., Aloia, T.A., Poston, G.J., Bjørnbeth, B.A., Vauthey, J.N. RAS Mutation Clinical Risk Score to Predict Survival After Resection of Colorectal Liver Metastases. Ann Surg. 269(1):120-126 (2019). doi: 10.1097/SLA.0000000000002319. PMID: 28549012.",
                           tags$a(
                             href = "https://doi.org/10.1097/sla.0000000000002319",
                             "View the publication",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"),style="padding-bottom: 20px"),
                       h4(strong('Nagashima score: '),"Nagashima, I., Takada, T., Adachi, M., Nagawa, H., Muto, T., Okinaga, K. Proposal of criteria to select candidates with colorectal liver metastases for hepatic resection: comparison of our scoring system to the positive number of risk factors. World J Gastroenterol.  12(39):6305-9 (2006). doi: 10.3748/wjg.v12.i39.6305. PMID: 17072953; PmCSID: PmCS4088138.",
                           tags$a(
                             href = "https://doi.org/10.3748/wjg.v12.i39.6305",
                             "View the publication",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"),style="padding-bottom: 20px"),
                        h4(strong('Nordlinger score: '), "Nordlinger B, Guiguet M, Vaillant JC, Balladur P, Boudjema K, Bachellier P, Jaeck D. Surgical resection of colorectal carcinoma metastases to the liver. A prognostic scoring system to improve case selection, based on 1568 patients. Association Française de Chirurgie. Cancer. 77(7):1254-62 (1996). PMID: 8608500.",
                          tags$a(
                            href = "http://www.ncbi.nlm.nih.gov/pubmed/8608500",
                            "View the publication",
                            tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                            target = "_blank"),style="padding-bottom: 20px"),
                        
                        h4(strong('Tumor burden score: '), "Sasaki, K., Morioka, D., Conci, S., Margonis, G.A., Sawada, Y., Ruzzenente, A., Kumamoto, T., Iacono, C., Andreatos, N., Guglielmi, A., Endo, I., Pawlik, T.M. The Tumor Burden Score: A New 'Metro-ticket' Prognostic Tool For Colorectal Liver Metastases Based on Tumor Size and Number of Tumors. Ann Surg. 267(1):132-141 (2018). doi: 10.1097/SLA.0000000000002064. PMID: 27763897.",
                           tags$a(
                             href = "https://doi.org/10.1097/sla.0000000000002064",
                             "View the publication",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"
                           ))
                        )
                      
                    ),
                    
                  )))
  
),


# ------------------------------------------------- ABOUT ---------------------------------------------------------  




  
  


tabPanel(title="About",
          id='about',
          div(style = "
                  
                  text-align: center;
                  min-width: 75%;     /* controls readable width */
                  padding: 10px;        /* adds space inside */
                  ",
              fluidRow(
              
              div(
                style = "padding-top: 5px; text-align: center; border: none; box-shadow: none; margin: auto;",
                
                h2("Information"),
                
                tags$hr(style="padding-bottom: 10px;"),
                column(
                  width=12,
                  class="jumbotron",
                  
                  column(
                    width=6,
                    div(
                      style= "padding-top: 50px",
                      tags$img(
                        src = "plato_logo_dark.svg",
                        height = "100%",#"500px",
                        width = "75%",#"700px",
                    ))),
                  
                  column(
                    width = 6,
                  
                  div(
                    style= "padding-top: 50px",
                p("PLATO (Personalized Liver metastases risk AssesmenT in Oncology) was developed to estimate the risk of relapse after colorectal cancer liver metastasis (CRLM) resection, building on established prognostic scores.
                  A logistic regression model was constructed using data from 709 CRLM operations.
                  This model translates the risk classes from published scores into a continuous percentage risk of relapse, providing a more clinically meaningful output."),
                  p(tags$a(
                             href = "https://github.com/vilja-a/plato-crlm-risk-prediction/",
                             "View the full source code.",
                             tagList(bsicons::bs_icon("box-arrow-up-right", class = "me-1", size = "1rem", style = "margin-left: 5px; vertical-align: top;")),
                             target = "_blank"),
                  style= "padding-bottom: 50px")
                ))))),
            

          ),
),

div(
  id = "footer",
  class = "footer",
  style = "text-align: center; padding-bottom: 30px",
  tags$a(
    href = "#top",
    "Back to top",
  )
),



)




# -------------------------- SERVER LOGIC -----------------------------

# Define server logic 
server <- function(input, output, session) {
  
  # Links by clicking sends to difference pages
  observeEvent(input$go_home, {
    updateNavbarPage(session, "main", selected = "home")
  })
  
  
  observeEvent(input$go_ref, {
    updateNavbarPage(session, "main", selected = "references")
  })
  
  thematic::thematic_shiny()

  # Checkbox logic
  # tumor stage
  numericStage <- reactive({
    val0 <- as.character(input$stage)
    switch(val0,
           "1" = 1,
           "2" = 2,
           "3" = 3,
           "4" = 4,
           "Unknown" = NA,
           NA)  # fallback if input is NULL
  })
  
  observe({
    print(paste("Mapped numeric value Stage:", numericStage()))
  })

  # tumor stage
  numericRAS <- reactive({
    val7 <- as.character(input$ras)
    switch(val7,
           "RAS wild type" = 0,
           "NRAS mutation" = 1,
           "KRAS mutation" = 3,
           "NRAS and KRAS mutations" = 2,
           "Unknown" = NA,
           NA)  # fallback if input is NULL
  })
  
  observe({
    print(paste("Mapped numeric value RAS:", numericRAS()))
  })
  
  

  # met count
  
  numericMetCount <- reactive({
    val <- as.numeric(input$MetCount)
  })
  
  observe({
    print(paste("Mapped numeric value MetCount:", numericMetCount()))
  })
  
  
  

  
  # margin
  
  numericMargin <- reactive({
    val1 <- as.character(input$Margin_mm)
    switch(val1,
           "<5" = 4,
           "5-9" = 6,
           "≥10" = 11,
           "Unknown" = NA,
           NA)  # fallback if input is NULL
  })
  
  observe({
    print(paste("Mapped numeric value Margin:", numericMargin()))
  })
  
  
  # size
  numericSize <- reactive({
    val2 <- as.numeric(input$Size_mm)

  })
  
  observe({
    print(paste("Mapped numeric value Size:", numericSize()))
  })
  
  
 
  # max viability
  numericViab <- reactive({
    val3 <- as.character(input$MaxVitality_p)
    switch(val3,
           "≤30" = 20,
           ">30" = 31,
           "Unknown" = NA,
           NA)  # fallback if input is NULL
  })
  
  observe({
    print(paste("Mapped numeric value Viability:", numericViab()))
  })
  

  # DFI
  numericDFI <- reactive({
    val4 <- as.character(input$DFI_months)
    switch(val4,
           "0" = 0,
           "1-11" = 10,
           "12-23" = 15,
           "≥24" = 31,
           "Unknown" = NA,
           NA)  # fallback if input is NULL
  })
  
  observe({
    print(paste("Mapped numeric value DFI:", numericDFI()))
  })
  
  
  # age
  numericAge <- reactive({
    val5 <- as.character(input$age_years)
    switch(val5,
           "≤60" = 55,
           ">60" = 70,
           "Unknown" = NA,
           NA)  # fallback if input is NULL
  })
  
  observe({
    print(paste("Mapped numeric value Age:", numericAge()))
  })
  

  # CEA
  numericCEA <- reactive({
    val6 <- as.character(input$preop_CEA_ugL)
    switch(val6,
           "<20" = 5,
           "20-199" = 100,
           "≥200" = 220,
           "Unknown" = NA,
           NA)  # fallback if input is NULL
  })
  
  
  observe({
    print(paste("Mapped numeric value CEA:", input$preop_CEA_ugL))
  })
  
  
  
  
  
#------------------ PLOTS ----------------------------------------------
        
        output$H_distPlot <- renderPlot({
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          stage_val <- numericStage()
          if (is.na(stage_val)) return(NULL)
          
          marg_val <- numericMargin()
          if (is.na(marg_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          viab_val <- numericViab()
          if (is.na(viab_val)) return(NULL)
          
          # generate bins based on input$bins from ui.R
          Helsinki_score = ifelse(input$node>0, 1,0)+as.numeric(input$VascInv)+as.numeric(input$BiliaryInv)+
            ifelse(stage_val>2,1,0)+ifelse(met_val>1, 1, 0)+
            ifelse(marg_val<5,1, 0)+ifelse(viab_val>30,1,0)+ifelse(size_val>50, 1, 0)
          
          
          
          
          # observation
          X_H <- c(1,
                   ifelse(input$node>0, 1,0),
                   ifelse(stage_val>2,1,0), 
                   ifelse(met_val>1, 1, 0),
                   ifelse(marg_val<5,1, 0),
                   ifelse(size_val>50, 1, 0),
                   ifelse(viab_val>30,1,0),
                   as.numeric(input$VascInv),
                   as.numeric(input$BiliaryInv))
          
          
          
          #1 year
          coefs1 <- c(
            H_coef_b1=-2.1143,
            H_pN_1= 0.6241,
            H_pT_1=0.2515,
            H_metc_1=0.8030,
            H_marg_1=0.2779,
            H_size_1=-0.1020,
            H_viab_1=0.2461,
            H_vasc_1=0.8022,
            H_bil_1=0.3608)
          
          
          #se
          H_coef_b1_se=0.3171
            H_pN_1_se= 0.1819
            H_pT_1_se=0.2512
            H_metc_1_se=0.1690
            H_marg_1_se=0.1906
            H_size_1_se=0.2322
            H_viab_1_se=0.1745
            H_vasc_1_se=0.1665
            H_bil_1_se=0.1768

          
          #covariance
          H1_cov_b1_c1 <- -0.0149460097
          H1_cov_b1_c2 <- -0.0438323418
          H1_cov_b1_c3 <- -0.0136945943
          H1_cov_b1_c4 <- -0.0279128246
          H1_cov_b1_c5 <- -0.0045810247
          H1_cov_b1_c6 <- -0.0151319119
          H1_cov_b1_c7 <- -0.0098588411
          H1_cov_b1_c8 <- 0.0009432987
          H1_cov_c1_c2 <- -0.0075766711
          H1_cov_c1_c3 <- 0.0011195702
          H1_cov_c1_c4 <- -0.0001908065
          H1_cov_c1_c5 <- -0.0013960039
          H1_cov_c1_c6 <- -0.0032118317
          H1_cov_c1_c7 <- 0.0031225864
          H1_cov_c1_c8 <- -0.0040825010
          H1_cov_c2_c3 <- -0.0054235808
          H1_cov_c2_c4 <- 0.0033661674
          H1_cov_c2_c5 <- 0.0040827759
          H1_cov_c2_c6 <- 0.0007466929
          H1_cov_c2_c7 <- -0.0023845576
          H1_cov_c2_c8 <- -0.0121936767
          H1_cov_c3_c4 <- -0.001061769
          H1_cov_c3_c5 <- -0.002903298
          H1_cov_c3_c6 <- -0.001256383
          H1_cov_c3_c7 <- 0.001631456
          H1_cov_c3_c8 <- 0.001451499
          H1_cov_c4_c5 <- -0.0015555353
          H1_cov_c4_c6 <- -0.0008994263
          H1_cov_c4_c7 <- -0.0021411680
          H1_cov_c4_c8 <--0.0002742310
          H1_cov_c5_c6 <- 0.001805497
          H1_cov_c5_c7 <- -0.006836891
          H1_cov_c5_c8 <- -0.001276030
          H1_cov_c6_c7 <- -5.021246e-03
          H1_cov_c6_c8 <- -9.660247e-05
          H1_cov_c7_c8 <- 0.001476783
          
          #Cov matrix
          V1_H <- matrix(c(
            H_coef_b1_se^2,   H1_cov_b1_c1,  H1_cov_b1_c2, H1_cov_b1_c3, H1_cov_b1_c4, H1_cov_b1_c5, H1_cov_b1_c6, H1_cov_b1_c7, H1_cov_b1_c8,
            H1_cov_b1_c1,  H_pN_1_se^2,  H1_cov_c1_c2, H1_cov_c1_c3, H1_cov_c1_c4, H1_cov_c1_c5, H1_cov_c1_c6, H1_cov_c1_c7, H1_cov_c1_c8,
            H1_cov_b1_c2,  H1_cov_c1_c2,  H_pT_1_se^2, H1_cov_c2_c3, H1_cov_c2_c4, H1_cov_c2_c5, H1_cov_c2_c6, H1_cov_c2_c7,H1_cov_c2_c8,
            H1_cov_b1_c3,  H1_cov_c1_c3, H1_cov_c2_c3, H_metc_1_se^2,H1_cov_c3_c4,H1_cov_c3_c5, H1_cov_c3_c6, H1_cov_c3_c7, H1_cov_c3_c8,
            H1_cov_b1_c4, H1_cov_c1_c4,H1_cov_c2_c4,H1_cov_c3_c4,H_marg_1_se^2, H1_cov_c4_c5, H1_cov_c4_c6, H1_cov_c4_c7, H1_cov_c4_c8,
            H1_cov_b1_c5, H1_cov_c1_c5,H1_cov_c2_c5,H1_cov_c3_c5,H1_cov_c4_c5, H_size_1_se^2, H1_cov_c5_c6, H1_cov_c5_c7,H1_cov_c5_c8,
            H1_cov_b1_c6, H1_cov_c1_c6, H1_cov_c2_c6,H1_cov_c3_c6,H1_cov_c4_c6, H1_cov_c5_c6, H_viab_1_se^2, H1_cov_c6_c7, H1_cov_c6_c8,
            H1_cov_b1_c7, H1_cov_c1_c7, H1_cov_c2_c7, H1_cov_c3_c7, H1_cov_c4_c7, H1_cov_c5_c7,H1_cov_c6_c7, H_vasc_1_se^2,H1_cov_c7_c8,
            H1_cov_b1_c8, H1_cov_c1_c8, H1_cov_c2_c8,H1_cov_c3_c8,H1_cov_c4_c8,H1_cov_c5_c8,H1_cov_c6_c8,H1_cov_c7_c8,H_bil_1_se^2
          ), nrow = 9, byrow = TRUE)
          
          
          #2 year
          coefs2 <- c(
            H_coef_b2=-1.1717,
            H_pN_2= 0.6050,
            H_pT_2=-0.0495,
            H_metc_2=0.6946,
            H_marg_2=0.3625,
            H_size_2=-0.1306,
            H_viab_2=0.1832,
            H_vasc_2=0.7186,
            H_bil_2=0.3225)
          
          #se
          H_coef_b2_se=0.2938
            H_pN_2_se=0.1793 
            H_pT_2_se=0.2415
            H_metc_2_se=0.1671
            H_marg_2_se=0.1877
            H_size_2_se=0.2380
            H_viab_2_se=0.1736
            H_vasc_2_se=0.1692
            H_bil_2_se=0.1822
            
            
            #covariance
            H2_cov_b1_c1 <- -0.0123433667
            H2_cov_b1_c2 <- -0.0379301847
            H2_cov_b1_c3 <- -0.0112909125
            H2_cov_b1_c4 <- -0.0264514636
            H2_cov_b1_c5 <- -0.0048051123
            H2_cov_b1_c6 <- -0.0140101177
            H2_cov_b1_c7 <- -0.0078131425
            H2_cov_b1_c8 <- 0.0009396368
            H2_cov_c1_c2 <- -8.151053e-03
            H2_cov_c1_c3 <- 8.258044e-04
            H2_cov_c1_c4 <- 9.205173e-06
            H2_cov_c1_c5 <- -1.058910e-03
            H2_cov_c1_c6 <- -3.584828e-03
            H2_cov_c1_c7 <-2.974860e-03 
            H2_cov_c1_c8 <--4.403222e-03
            H2_cov_c2_c3 <- -0.005819672
            H2_cov_c2_c4 <- 0.002766988
            H2_cov_c2_c5 <- 0.004105932
            H2_cov_c2_c6 <- 0.000709247
            H2_cov_c2_c7 <- -0.003044747
            H2_cov_c2_c8 <- -0.012155059
            H2_cov_c3_c4 <- -0.0007558563
            H2_cov_c3_c5 <- -0.0028119970
            H2_cov_c3_c6 <- -0.0015112921
            H2_cov_c3_c7 <- 0.0012891882
            H2_cov_c3_c8 <- 0.0011447394
            H2_cov_c4_c5 <- -1.620562e-03
            H2_cov_c4_c6 <- -8.403790e-04
            H2_cov_c4_c7 <- -2.213306e-03
            H2_cov_c4_c8 <--1.030480e-05
            H2_cov_c5_c6 <- 0.001457570
            H2_cov_c5_c7 <- -0.007668350
            H2_cov_c5_c8 <- -0.001238951
            H2_cov_c6_c7 <- -5.294319e-03
            H2_cov_c6_c8 <- -3.687335e-05
            H2_cov_c7_c8 <- 0.001369554
            
            #Cov matrix
            V2_H <- matrix(c(
              H_coef_b2_se^2,   H2_cov_b1_c1,  H2_cov_b1_c2, H2_cov_b1_c3, H2_cov_b1_c4, H2_cov_b1_c5, H2_cov_b1_c6, H2_cov_b1_c7, H2_cov_b1_c8,
              H2_cov_b1_c1,  H_pN_2_se^2,  H2_cov_c1_c2, H2_cov_c1_c3, H2_cov_c1_c4, H2_cov_c1_c5, H2_cov_c1_c6, H2_cov_c1_c7, H2_cov_c1_c8,
              H2_cov_b1_c2,  H2_cov_c1_c2,  H_pT_2_se^2, H2_cov_c2_c3, H2_cov_c2_c4, H2_cov_c2_c5, H2_cov_c2_c6, H2_cov_c2_c7,H2_cov_c2_c8,
              H2_cov_b1_c3,  H2_cov_c1_c3, H2_cov_c2_c3, H_metc_2_se^2,H2_cov_c3_c4,H2_cov_c3_c5, H2_cov_c3_c6, H2_cov_c3_c7, H2_cov_c3_c8,
              H2_cov_b1_c4, H2_cov_c1_c4,H2_cov_c2_c4,H2_cov_c3_c4,H_marg_2_se^2, H2_cov_c4_c5, H2_cov_c4_c6, H2_cov_c4_c7, H2_cov_c4_c8,
              H2_cov_b1_c5, H2_cov_c1_c5,H2_cov_c2_c5,H2_cov_c3_c5,H2_cov_c4_c5, H_size_2_se^2, H2_cov_c5_c6, H2_cov_c5_c7,H2_cov_c5_c8,
              H2_cov_b1_c6, H2_cov_c1_c6, H2_cov_c2_c6,H2_cov_c3_c6,H2_cov_c4_c6, H2_cov_c5_c6, H_viab_2_se^2, H2_cov_c6_c7, H2_cov_c6_c8,
              H2_cov_b1_c7, H2_cov_c1_c7, H2_cov_c2_c7, H2_cov_c3_c7, H2_cov_c4_c7, H2_cov_c5_c7,H2_cov_c6_c7, H_vasc_2_se^2,H2_cov_c7_c8,
              H2_cov_b1_c8, H2_cov_c1_c8, H2_cov_c2_c8,H2_cov_c3_c8,H2_cov_c4_c8,H2_cov_c5_c8,H2_cov_c6_c8,H2_cov_c7_c8,H_bil_2_se^2
            ), nrow = 9, byrow = TRUE)
          
          #3year
          coefs3 <- c(
            H_coef_b3=-0.9999,
            H_pN_3= 0.0168,
            H_pT_3=0.5771,
            H_metc_3=0.7245,
            H_marg_3=0.3826,
            H_size_3=-0.1123,
            H_viab_3=0.2662,
            H_vasc_3=0.6610,
            H_bil_3=0.2672)
          
          #se
          H_coef_b3_se=0.3023
            H_pN_3_se= 0.1869
            H_pT_3_se=0.2489
            H_metc_3_se=0.1743
            H_marg_3_se=0.1956
            H_size_3_se=0.2498
            H_viab_3_se=0.1809
            H_vasc_3_se=0.1782
            H_bil_3_se=0.1934
            
            
            #covariance
            H3_cov_b1_c1 <- -0.012961931
            H3_cov_b1_c2 <- -0.040243657
            H3_cov_b1_c3 <- -0.012358981
            H3_cov_b1_c4 <- -0.028732361
            H3_cov_b1_c5 <- -0.005506481
            H3_cov_b1_c6 <- -0.015178288
            H3_cov_b1_c7 <- -0.008208685
            H3_cov_b1_c8 <- 0.001456190
            H3_cov_c1_c2 <- -0.0084608794
            H3_cov_c1_c3 <- 0.0006668956
            H3_cov_c1_c4 <- -0.0002269839
            H3_cov_c1_c5 <- -0.0009437315
            H3_cov_c1_c6 <- -0.0037161856
            H3_cov_c1_c7 <- 0.0030922852
            H3_cov_c1_c8 <--0.0052149791
            H3_cov_c2_c3 <- -0.0059177842
            H3_cov_c2_c4 <- 0.0030085382
            H3_cov_c2_c5 <- 0.0042928374
            H3_cov_c2_c6 <- 0.0005899472
            H3_cov_c2_c7 <- -0.0032626220
            H3_cov_c2_c8 <- -0.0132724261
            H3_cov_c3_c4 <- -0.0001588139
            H3_cov_c3_c5 <- -0.0026069193
            H3_cov_c3_c6 <- -0.0013182269
            H3_cov_c3_c7 <- 0.0010204572
            H3_cov_c3_c8 <- 0.0006524484
            H3_cov_c4_c5 <- -0.0015671693
            H3_cov_c4_c6 <- -0.0009525762
            H3_cov_c4_c7 <- -0.0024779470
            H3_cov_c4_c8 <-0.0001494358
            H3_cov_c5_c6 <- 0.0013057013
            H3_cov_c5_c7 <- -0.0087781411
            H3_cov_c5_c8 <- -0.0015335210
            H3_cov_c6_c7 <- -0.0054597182
            H3_cov_c6_c8 <- -0.0001179000
            H3_cov_c7_c8 <- 0.001372520
            
            #Cov matrix
            V3_H <- matrix(c(
              H_coef_b3_se^2,   H3_cov_b1_c1,  H3_cov_b1_c2, H3_cov_b1_c3, H3_cov_b1_c4, H3_cov_b1_c5, H3_cov_b1_c6, H3_cov_b1_c7, H3_cov_b1_c8,
              H3_cov_b1_c1,  H_pN_3_se^2,  H3_cov_c1_c2, H3_cov_c1_c3, H3_cov_c1_c4, H3_cov_c1_c5, H3_cov_c1_c6, H3_cov_c1_c7, H3_cov_c1_c8,
              H3_cov_b1_c2,  H3_cov_c1_c2,  H_pT_3_se^2, H3_cov_c2_c3, H3_cov_c2_c4, H3_cov_c2_c5, H3_cov_c2_c6, H3_cov_c2_c7,H3_cov_c2_c8,
              H3_cov_b1_c3,  H3_cov_c1_c3, H3_cov_c2_c3, H_metc_3_se^2,H3_cov_c3_c4,H3_cov_c3_c5, H3_cov_c3_c6, H3_cov_c3_c7, H3_cov_c3_c8,
              H3_cov_b1_c4, H3_cov_c1_c4,H3_cov_c2_c4,H3_cov_c3_c4,H_marg_3_se^2, H3_cov_c4_c5, H3_cov_c4_c6, H3_cov_c4_c7, H3_cov_c4_c8,
              H3_cov_b1_c5, H3_cov_c1_c5,H3_cov_c2_c5,H3_cov_c3_c5,H3_cov_c4_c5, H_size_3_se^2, H3_cov_c5_c6, H3_cov_c5_c7,H3_cov_c5_c8,
              H3_cov_b1_c6, H3_cov_c1_c6, H3_cov_c2_c6,H3_cov_c3_c6,H3_cov_c4_c6, H3_cov_c5_c6, H_viab_3_se^2, H3_cov_c6_c7, H3_cov_c6_c8,
              H3_cov_b1_c7, H3_cov_c1_c7, H3_cov_c2_c7, H3_cov_c3_c7, H3_cov_c4_c7, H3_cov_c5_c7,H3_cov_c6_c7, H_vasc_3_se^2,H3_cov_c7_c8,
              H3_cov_b1_c8, H3_cov_c1_c8, H3_cov_c2_c8,H3_cov_c3_c8,H3_cov_c4_c8,H3_cov_c5_c8,H3_cov_c6_c8,H3_cov_c7_c8,H_bil_3_se^2
            ), nrow = 9, byrow = TRUE)
          
          
          
          #1 year
          y_hat_H1  <- sum(X_H * coefs1)
          se_hat_H1 <- sqrt(t(X_H) %*% V1_H %*% X_H)
          ci_lower1 <- y_hat_H1 - 1.96 * se_hat_H1
          ci_upper1 <- y_hat_H1 + 1.96 * se_hat_H1
          
          mean1=plogis(y_hat_H1)*100
          CI_lower1=plogis(ci_lower1)*100
          CI_upper1=plogis(ci_upper1)*100
          
          
          
          #2 year
          y_hat_H2  <- sum(X_H * coefs2)
          se_hat_H2 <- sqrt(t(X_H) %*% V2_H %*% X_H)
          ci_lower2 <- y_hat_H2 - 1.96 * se_hat_H2
          ci_upper2 <- y_hat_H2 + 1.96 * se_hat_H2
          
          mean2=plogis(y_hat_H2)*100
          CI_lower2=plogis(ci_lower2)*100
          CI_upper2=plogis(ci_upper2)*100
          
          #3 year
          y_hat_H3  <- sum(X_H * coefs3)
          se_hat_H3 <- sqrt(t(X_H) %*% V3_H %*% X_H)
          ci_lower3 <- y_hat_H3 - 1.96 * se_hat_H3
          ci_upper3 <- y_hat_H3 + 1.96 * se_hat_H3
          
          mean3=plogis(y_hat_H3)*100
          CI_lower3=plogis(ci_lower3)*100
          CI_upper3=plogis(ci_upper3)*100
          
          
          data <- data.frame(RelapseRisk=c('1-year', '2-year', '3-year'),
                             Mean=c(mean1, mean2, mean3),
                             CI_lower=c(CI_lower1, CI_lower2, CI_lower3),
                             CI_upper=c(CI_upper1, CI_upper2, CI_upper3))

        # draw the histogram with the specified number of bins
          p <- barplot(
            height = data$Mean,
            col = post_colors,
            ylim = c(0, 100),
            border =  NA, 
            ylab = "RISK OF RELAPSE (%)",
            cex.names = 1.2,   # size of x-axis labels
            cex.lab = 1.2,     # size of y-axis label
            main = ""          # title
          )
          
          # Add error bars
          arrows(
            x0 = p,
            y0 = data$CI_lower,
            x1 = p,
            y1 = data$CI_upper,
            angle = 90,
            code = 3,
            length = 0.1,
            lwd = 1.5
          )
          
          axis(1, at = p, labels = data$RelapseRisk, tick = F)
    })
        output$H_score <- renderText({
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          stage_val <- numericStage()
          if (is.na(stage_val)) return(NULL)
          
          marg_val <- numericMargin()
          if (is.na(marg_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          viab_val <- numericViab()
          if (is.na(viab_val)) return(NULL)
          
          Helsinki_score = ifelse(input$node>0, 1,0)+as.numeric(input$VascInv)+as.numeric(input$BiliaryInv)+
            ifelse(stage_val>2,1,0)+ifelse(met_val>1, 1, 0)+
            ifelse(marg_val<5,1, 0)+ifelse(viab_val>30,1,0)+ifelse(size_val>50, 1, 0)
          
          
          
          
          #3 year
          coefs3 <- c(
            H_coef_b3=-0.9999,
            H_pN_3= 0.0168,
            H_pT_3=0.5771,
            H_metc_3=0.7245,
            H_marg_3=0.3826,
            H_size_3=-0.1123,
            H_viab_3=0.2662,
            H_vasc_3=0.6610,
            H_bil_3=0.2672)
          
          X_H <- c(1,
                   ifelse(input$node>0, 1,0),
                   ifelse(stage_val>2,1,0), 
                   ifelse(met_val>1, 1, 0),
                   ifelse(marg_val<5,1, 0),
                   ifelse(size_val>50, 1, 0),
                   ifelse(viab_val>30,1,0),
                   as.numeric(input$VascInv),
                   as.numeric(input$BiliaryInv))
          
          y_hat_H3  <- sum(X_H * coefs3)
          mean3_H=round(plogis(y_hat_H3)*100)
          
          
         
        
        HTML(paste0("<h3>", "Helsinki score: ", '<span class=" h3 text-primary">', Helsinki_score, "</span>",
                    "<h5>", "3-year estimated relapse risk: ", '<span class=" h2 text-primary">', mean3_H, "%",'</span>',
                    "<br>",
                    #"<h5>", "95% confidence interval: ", '<span class=" h2 text-primary">', CI_lower3_H, "-", CI_upper3_H, "%",'</span>',
                    "<br>",
                    "<br>",
                    
                    '<h6><i>Low risk: 0-2<br>
                      Moderate risk: 3-4<br>
                      High risk: 5-8
                      <i></h6>'
        ))
        
})
        
        
        
        # Modified Clinical Risk score
        
        output$mCS_distPlot <- renderPlot({
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          ras_val <- numericRAS()
          if (is.na(ras_val)) return(NULL)
          
          # observation
          X_mCS <- c(1, ifelse(ras_val>0, 1,0), ifelse(input$node>0, 1,0), ifelse(size_val>50, 1, 0))

          #1 year
          coefs1 <- c(
          mCS_coef_b1=-0.6323,
          mCS_RAS_1=0.0909,
          mCS_pN_1= 0.7303,
          mCS_size_1=0.1700)
          
          #se
          mCS_coef_se_b1 <- 0.1582
          mCS_RAS_se_1 <- 0.1532
          mCS_pN_se_1 <- 0.1669
          mCS_size_se_1 <- 0.2177
          
          #covariance
          mCS1_cov_b1_c1 <- -0.010434523
          mCS1_cov_b1_c2 <- -0.018531638
          mCS1_cov_b1_c3 <- -0.007728005
          mCS1_cov_c1_c2 <- -0.001957917
          mCS1_cov_c1_c3 <- 0.001669383
          mCS1_cov_c2_c3 <- 0.0001331509
          
          #Cov matrix
          V1_mCS <- matrix(c(
            mCS_coef_se_b1^2,   mCS1_cov_b1_c1,  mCS1_cov_b1_c2, mCS1_cov_b1_c3,
            mCS1_cov_b1_c1,  mCS_RAS_se_1^2,  mCS1_cov_c1_c2, mCS1_cov_c1_c3,
            mCS1_cov_b1_c2,  mCS1_cov_c1_c2,  mCS_pN_se_1^2, mCS1_cov_c2_c3,
            mCS1_cov_b1_c3,  mCS1_cov_c1_c3, mCS1_cov_c2_c3, mCS_size_se_1^2
          ), nrow = 4, byrow = TRUE)
          
          #2 year
          coefs2 <- c(
          mCS_coef_b2 = -0.1098,
          mCS_RAS_2 = 0.2067,
          mCS_pN_2 = 0.6546,
          mCS_size_2 = 0.1486)
          
          #se
          mCS_coef_se_b2 <- 0.1539
          mCS_RAS_se_2 <- 0.1569
          mCS_pN_se_2 <- 0.1652
          mCS_size_se_2 <- 0.2254
          
          #covariance
          mCS2_cov_b_c1 <- -0.010813082
          mCS2_cov_b_c2 <- -0.017134549
          mCS2_cov_b_c3 <- -0.008046981
          mCS2_cov_c1_c2 <--0.001836664 
          mCS2_cov_c1_c3 <-0.001872857
          mCS2_cov_c2_c3 <- 6.914979e-05
          
          #Cov matrix
          V2_mCS <- matrix(c(
            mCS_coef_se_b2^2,   mCS2_cov_b_c1,  mCS2_cov_b_c2, mCS2_cov_b_c3,
            mCS2_cov_b_c1,  mCS_RAS_se_2^2,  mCS2_cov_c1_c2, mCS2_cov_c1_c3,
            mCS2_cov_b_c2,  mCS2_cov_c1_c2,  mCS_pN_se_2^2, mCS2_cov_c2_c3,
            mCS2_cov_b_c3,  mCS2_cov_c1_c3, mCS2_cov_c2_c3, mCS_size_se_2^2
          ), nrow = 4, byrow = TRUE)
          
          #3 year
          coefs3 <- c(
          mCS_coef_b3=0.1435,
          mCS_RAS_3=0.1911,
          mCS_pN_3=0.6476,
          mCS_size_3=0.1449)
          
          #se
          mCS_coef_se_b3 <- 0.1584
          mCS_RAS_se_3 <- 0.1655
          mCS_pN_se_3 <- 0.1724
          mCS_size_se_3 <- 0.2365
          
          #covariance
          mCS3_cov_b_c1 <- -0.011628545
          mCS3_cov_b_c2 <- -0.017999592
          mCS3_cov_b_c3 <- -0.008750116
          mCS3_cov_c1_c2 <- -0.002454200
          mCS3_cov_c1_c3 <- 0.001854052
          mCS3_cov_c2_c3 <- -2.543666e-05
          
          #Cov matrix
          V3_mCS <- matrix(c(
            mCS_coef_se_b3^2,   mCS3_cov_b_c1,  mCS3_cov_b_c2, mCS3_cov_b_c3,
            mCS3_cov_b_c1,  mCS_RAS_se_3^2,  mCS3_cov_c1_c2, mCS3_cov_c1_c3,
            mCS3_cov_b_c2,  mCS3_cov_c1_c2,  mCS_pN_se_3^2, mCS3_cov_c2_c3,
            mCS3_cov_b_c3,  mCS3_cov_c1_c3, mCS3_cov_c2_c3, mCS_size_se_3^2
          ), nrow = 4, byrow = TRUE)
          
          
          
          #mCS
          #1 year
          y_hat_mCS1  <- sum(X_mCS * coefs1)
          se_hat_mCS1 <- sqrt(t(X_mCS) %*% V1_mCS %*% X_mCS)
          ci_lower1 <- y_hat_mCS1 - 1.96 * se_hat_mCS1
          ci_upper1 <- y_hat_mCS1 + 1.96 * se_hat_mCS1
          
          mean1=plogis(y_hat_mCS1)*100
          CI_lower1=plogis(ci_lower1)*100
          CI_upper1=plogis(ci_upper1)*100
          

          
          #2 year
          y_hat_mCS2  <- sum(X_mCS * coefs2)
          se_hat_mCS2 <- sqrt(t(X_mCS) %*% V2_mCS %*% X_mCS)
          ci_lower2 <- y_hat_mCS2 - 1.96 * se_hat_mCS2
          ci_upper2 <- y_hat_mCS2 + 1.96 * se_hat_mCS2
          
          mean2=plogis(y_hat_mCS2)*100
          CI_lower2=plogis(ci_lower2)*100
          CI_upper2=plogis(ci_upper2)*100
          
          #3 year
          y_hat_mCS3  <- sum(X_mCS * coefs3)
          se_hat_mCS3 <- sqrt(t(X_mCS) %*% V3_mCS %*% X_mCS)
          ci_lower3 <- y_hat_mCS3 - 1.96 * se_hat_mCS3
          ci_upper3 <- y_hat_mCS3 + 1.96 * se_hat_mCS3
          
          mean3=plogis(y_hat_mCS3)*100
          CI_lower3=plogis(ci_lower3)*100
          CI_upper3=plogis(ci_upper3)*100

          
          
          
          data <- data.frame(RelapseRisk=c('1-year', '2-year', '3-year'),
                             Mean=c(mean1, mean2, mean3),
                             CI_lower=c(CI_lower1, CI_lower2, CI_lower3),
                             CI_upper=c(CI_upper1, CI_upper2, CI_upper3))
          

          p <- barplot(
            height = data$Mean,
            col = colors,
            ylim = c(0, 100),
            border = NA,      
            ylab = "RISK OF RELAPSE (%)",
            cex.names = 1.2,   
            cex.lab = 1.2,     
            main = ""      
          )
          
          # Add error bars
          arrows(
            x0 = p,
            y0 = data$CI_lower,
            x1 = p,
            y1 = data$CI_upper,
            angle = 90,
            code = 3,
            length = 0.1,
            lwd = 1.5
          )
          
          
          axis(1, at = p, labels = data$RelapseRisk, tick = FALSE)
        })
        output$mCS_score <- renderText({
          
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          ras_val <- numericRAS()
          if (is.na(ras_val)) return(NULL)
          
          S_RAS=ifelse(ras_val>0, 1,0)
          S_pN_status=ifelse(input$node>0, 1,0)
          S_size=ifelse(size_val>50, 1, 0)
          

          mCS_score = ifelse(input$node>0, 1,0)+ifelse(ras_val>0, 1,0)+ifelse(size_val>50, 1, 0)
          X_mCS <- c(1, ifelse(ras_val>0, 1,0), ifelse(input$node>0, 1,0), ifelse(size_val>50, 1, 0))
      
          #3 year
          coefs3 <- c(
            mCS_coef_b3=0.1435,
            mCS_RAS_3=0.1911,
            mCS_pN_3=0.6476,
            mCS_size_3=0.1449)
          
          y_hat_mCS3  <- sum(X_mCS * coefs3)
          mean3_mCS=round(plogis(y_hat_mCS3)*100)

          
          
          HTML(paste0( 
                      "<h3>", "m-CS score: ", '<span class=" h3 text-primary">', mCS_score, '</span>',
                      "<br>",
                      "<h5>", "3-year estimated relapse risk: ", '<span class=" h2 text-primary">', mean3_mCS, "%",'</span>',
                      "<br>",
                      
                      "<br>",
                      "<h6><i>Low risk: 0<br>",
                      "Intermediate risk: 1<br>",
                      "Moderate risk: 2<br>",
                      "High risk: 3",
                      "<i></h6>"))
          
        })
        
        # Fong score
        
        output$F_distPlot <- renderPlot({
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          cea_val <- numericCEA()
          if (is.na(size_val)) return(NULL)
          
          
          
          # observation
          X_F <- c(1, ifelse(input$node>0, 1,0), ifelse(dfi_val<12,1,0), ifelse(met_val>1, 1, 0), ifelse(size_val>50, 1, 0), ifelse(cea_val>200,1,0))
          
          
          
          #1 year
          coefs1 <- c(
          F_coef_b1 =-1.3617,
          F_pN_1 = 0.6639,
          F_dfi12m_1 = 0.4970,
          F_mcount_1 = 0.7321,
          F_size_1 =0.1261,
          F_cea_1= -0.1354)
          #se
          F_coef_se_b1 <-0.2093
          F_pN_se_1 <- 0.1714
          F_dfi12m_se_1 <- 0.1886
          F_mcount_se_1 <- 0.1684
          F_size_se_1 <-0.2257
          F_cea_se_1<- 0.3573
          
          #covariance
          F1_cov_b1_c1 <- -0.018665809
          F1_cov_b1_c2 <- -0.020198607
          F1_cov_b1_c3 <- -0.012665732
          F1_cov_b1_c4 <- -0.006478511
          F1_cov_b1_c5 <- -0.005887583
          F1_cov_c1_c2 <- -0.0032587191
          F1_cov_c1_c3 <- 0.0009428457
          F1_cov_c1_c4 <- -0.0001735474
          F1_cov_c1_c5 <- 0.0001902175
          F1_cov_c2_c3 <- -0.007543916
          F1_cov_c2_c4 <- 0.001672070
          F1_cov_c2_c5 <- 0.003182577
          F1_cov_c3_c4 <- -0.0023727322
          F1_cov_c3_c5 <- -0.0034300100
          F1_cov_c4_c5 <- -0.0068813157
            
          
          #Cov matrix
          V1_F <- matrix(c(
            F_coef_se_b1^2,   F1_cov_b1_c1,  F1_cov_b1_c2, F1_cov_b1_c3,F1_cov_b1_c4,F1_cov_b1_c5,
            F1_cov_b1_c1, F_pN_se_1^2,  F1_cov_c1_c2, F1_cov_c1_c3, F1_cov_c1_c4, F1_cov_c1_c5,
            F1_cov_b1_c2, F1_cov_c1_c2, F_dfi12m_se_1^2, F1_cov_c2_c3, F1_cov_c2_c4, F1_cov_c2_c5,
            F1_cov_b1_c3, F1_cov_c1_c3, F1_cov_c2_c3, F_mcount_se_1^2, F1_cov_c3_c4, F1_cov_c3_c5,
            F1_cov_b1_c4, F1_cov_c1_c4, F1_cov_c2_c4, F1_cov_c3_c4, F_size_se_1^2,F1_cov_c4_c5,
            F1_cov_b1_c5, F1_cov_c1_c5, F1_cov_c2_c5, F1_cov_c3_c5, F1_cov_c4_c5, F_cea_se_1^2
          ), nrow = 6, byrow = TRUE)
          
          
          #2 year
          coefs2 <- c(
          F_coef_b2 =-0.5731,
          F_pN_2 =0.6150,
          F_dfi12m_2 =0.2825,
          F_mcount_2 =0.6512,
          F_size_2 =0.0996,
          F_cea_2=-0.0917)
          
          #se
          F_coef_se_b2 <-0.1943
          F_pN_se_2 <-0.1687
          F_dfi12m_se_2 <-0.1849
          F_mcount_se_2 <-0.1677
          F_size_se_2 <-0.2309
          F_cea_se_2<-0.3588
          
          #covariance
          F2_cov_b1_c1 <- -0.016561656
            F2_cov_b1_c2 <- -0.017729635
            F2_cov_b1_c3 <- -0.010813668
            F2_cov_b1_c4 <- -0.006992839
            F2_cov_b1_c5 <- -0.006842333
            F2_cov_c1_c2 <- -0.0037655106
            F2_cov_c1_c3 <- 0.0007345809
            F2_cov_c1_c4 <- 0.0001608163
            F2_cov_c1_c5 <- 0.0005391608
            F2_cov_c2_c3 <- -0.008193308
            F2_cov_c2_c4 <- 0.001640683
            F2_cov_c2_c5 <- 0.003565288
            F2_cov_c3_c4 <- -0.0022165094
            F2_cov_c3_c5 <- -0.0031270699
            F2_cov_c4_c5 <- -0.0067715153
            
            
            #Cov matrix
            V2_F <- matrix(c(
              F_coef_se_b2^2,   F2_cov_b1_c1,  F2_cov_b1_c2, F2_cov_b1_c3,F2_cov_b1_c4,F2_cov_b1_c5,
              F2_cov_b1_c1, F_pN_se_2^2,  F2_cov_c1_c2, F2_cov_c1_c3, F2_cov_c1_c4, F2_cov_c1_c5,
              F2_cov_b1_c2, F2_cov_c1_c2, F_dfi12m_se_2^2, F2_cov_c2_c3, F2_cov_c2_c4, F2_cov_c2_c5,
              F2_cov_b1_c3, F2_cov_c1_c3, F2_cov_c2_c3, F_mcount_se_2^2, F2_cov_c3_c4, F2_cov_c3_c5,
              F2_cov_b1_c4, F2_cov_c1_c4, F2_cov_c2_c4, F2_cov_c3_c4, F_size_se_2^2,F2_cov_c4_c5,
              F2_cov_b1_c5, F2_cov_c1_c5, F2_cov_c2_c5, F2_cov_c3_c5, F2_cov_c4_c5, F_cea_se_2^2
            ), nrow = 6, byrow = TRUE)
          
          #3 year
          coefs3 <- c(
          F_coef_b3 =-0.3897,
          F_pN_3 =0.5960,
          F_dfi12m_3 =0.3703,
          F_mcount_3 =0.6678,
          F_size_3 =0.1161,
          F_cea_3=-0.0854)
          
          #se
          F_coef_se_b3 <-0.2001
          F_pN_se_3 <-0.1762
          F_dfi12m_se_3 <-0.1930
          F_mcount_se_3 <-0.1764
          F_size_se_3 <-0.2430
          F_cea_se_3<-0.3706
          
          #covariance
          F3_cov_b1_c1 <- -0.017816942
            F3_cov_b1_c2 <- -0.019070521
            F3_cov_b1_c3 <- -0.011153181
            F3_cov_b1_c4 <- -0.008407397
            F3_cov_b1_c5 <- -0.007990505
            F3_cov_c1_c2 <- -0.0037343495
            F3_cov_c1_c3 <- 0.0005459224
            F3_cov_c1_c4 <- 0.0003287314
            F3_cov_c1_c5 <- 0.0007946832
            F3_cov_c2_c3 <- -0.009394912
            F3_cov_c2_c4 <- 0.002190206
            F3_cov_c2_c5 <- 0.004157055
            F3_cov_c3_c4 <- -0.0020671182
            F3_cov_c3_c5 <- -0.0034214982
            F3_cov_c4_c5 <- -0.0071304512
            
            
            #Cov matrix
            V3_F <- matrix(c(
              F_coef_se_b3^2,   F3_cov_b1_c1,  F3_cov_b1_c2, F3_cov_b1_c3,F3_cov_b1_c4,F3_cov_b1_c5,
              F3_cov_b1_c1, F_pN_se_3^2,  F3_cov_c1_c2, F3_cov_c1_c3, F3_cov_c1_c4, F3_cov_c1_c5,
              F3_cov_b1_c2, F3_cov_c1_c2, F_dfi12m_se_3^2, F3_cov_c2_c3, F3_cov_c2_c4, F3_cov_c2_c5,
              F3_cov_b1_c3, F3_cov_c1_c3, F3_cov_c2_c3, F_mcount_se_3^2, F3_cov_c3_c4, F3_cov_c3_c5,
              F3_cov_b1_c4, F3_cov_c1_c4, F3_cov_c2_c4, F3_cov_c3_c4, F_size_se_3^2,F3_cov_c4_c5,
              F3_cov_b1_c5, F3_cov_c1_c5, F3_cov_c2_c5, F3_cov_c3_c5, F3_cov_c4_c5, F_cea_se_3^2
            ), nrow = 6, byrow = TRUE)
          
          #1 year
          y_hat_F1  <- sum(X_F * coefs1)
          se_hat_F1 <- sqrt(t(X_F) %*% V1_F %*% X_F)
          ci_lower1 <- y_hat_F1 - 1.96 * se_hat_F1
          ci_upper1 <- y_hat_F1 + 1.96 * se_hat_F1
          
          mean1=plogis(y_hat_F1)*100
          CI_lower1=plogis(ci_lower1)*100
          CI_upper1=plogis(ci_upper1)*100
          
          
          
          #2 year
          y_hat_F2  <- sum(X_F * coefs2)
          se_hat_F2 <- sqrt(t(X_F) %*% V2_F %*% X_F)
          ci_lower2 <- y_hat_F2 - 1.96 * se_hat_F2
          ci_upper2 <- y_hat_F2 + 1.96 * se_hat_F2
          
          mean2=plogis(y_hat_F2)*100
          CI_lower2=plogis(ci_lower2)*100
          CI_upper2=plogis(ci_upper2)*100
          
          #3 year
          y_hat_F3  <- sum(X_F * coefs3)
          se_hat_F3 <- sqrt(t(X_F) %*% V3_F %*% X_F)
          ci_lower3 <- y_hat_F3 - 1.96 * se_hat_F3
          ci_upper3 <- y_hat_F3 + 1.96 * se_hat_F3
          
          mean3=plogis(y_hat_F3)*100
          CI_lower3=plogis(ci_lower3)*100
          CI_upper3=plogis(ci_upper3)*100
          
          
          data <- data.frame(RelapseRisk=c('1-year', '2-year', '3-year'),
                             Mean=c(mean1, mean2, mean3),
                             CI_lower=c(CI_lower1, CI_lower2, CI_lower3),
                             CI_upper=c(CI_upper1, CI_upper2, CI_upper3))
          
          # draw the histogram with the specified number of bins
          p <- barplot(
              height = data$Mean,
              col = colors,
              ylim = c(0, 100),
              border = NA,
              ylab = "RISK OF RELAPSE (%)",
              cex.names = 1.2, 
              cex.lab = 1.2,
              main = ""     
            )
          
          # Add error bars
          arrows(
            x0 = p,
            y0 = data$CI_lower,
            x1 = p,
            y1 = data$CI_upper,
            angle = 90,
            code = 3,
            length = 0.1,
            lwd = 1.5
          )
          
          
          axis(1, at = p, labels = data$RelapseRisk, tick = FALSE)
          
            
            
        })
        output$F_score <- renderText({
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          cea_val <- numericCEA()
          if (is.na(cea_val)) return(NULL)
          
          S_pN_status <- ifelse(input$node>0, 1,0)
          S_dfi12m <- ifelse(dfi_val<12,1,0)
          S_MetCount_1 <- ifelse(met_val>1, 1, 0)
          S_size <- ifelse(size_val>50, 1, 0)
          S_preopCEA_200 <- ifelse(cea_val>200,1,0)
          
          
          Fong_score = ifelse(input$node>0, 1,0)+ifelse(dfi_val<12,1,0)+
            ifelse(met_val>1, 1, 0)+ifelse(size_val>50, 1, 0)+ifelse(cea_val>200,1,0)
          
          X_F <- c(1, ifelse(input$node>0, 1,0), ifelse(dfi_val<12,1,0), ifelse(met_val>1, 1, 0), ifelse(size_val>50, 1, 0), ifelse(cea_val>200,1,0))
          
          #3 year
          coefs3 <- c(
            F_coef_b3 =-0.3897,
            F_pN_3 =0.5960,
            F_dfi12m_3 =0.3703,
            F_mcount_3 =0.6678,
            F_size_3 =0.1161,
            F_cea_3=-0.0854)
          
          #3 year
          y_hat_F3  <- sum(X_F * coefs3)
          mean3_F=round(plogis(y_hat_F3)*100)
          
          HTML(paste0("<h3>", "Fong score: ", '<span class=" h3 text-primary">', Fong_score, '</span>',
                      "<h5>", "3-year estimated relapse risk: ", '<span class=" h2 text-primary">', mean3_F, "%",'</span>',
                      "<br>",
                      "<br>",
                      
                      '<h6><i>Low risk: 0-2<br>
                      Moderate risk: 3-4<br>
                      High risk: 5
                      <i></h6>'
                      ))
          
        })
        
        
        
        # Nordlinger score
        
        output$N_distPlot <- renderPlot({
          
          stage_val <- numericStage()
          if (is.na(stage_val)) return(NULL)
          
          marg_val <- numericMargin()
          if (is.na(marg_val)) return(NULL)
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          age_val <- numericAge()
          if (is.na(age_val)) return(NULL)
          
          
          # observation
          X_No <- c(1,
                   ifelse(input$node>0, 1,0),
                   ifelse(stage_val>3,1,0),
                   ifelse(dfi_val<24,1,0),
                   ifelse(met_val>3, 1, 0),
                   ifelse(size_val>50, 1, 0),
                   ifelse(marg_val<10,1, 0),
                   ifelse(age_val>60,1,0))
          
          
          
          #1 year
          coefs1 <- c(
            No_coef_b1=-2.0961,
            No_pN_1= 0.6420,
            No_pT_1=0.4194,
            No_dfi_1=0.4534,
            No_metc_1=1.0157,
            No_size_1=0.1601,
            No_marg_1=0.6526,
            No_age_1=0.1588)
            
            
          
          
          #se
          No_coef_b1_se=0.4105
          No_pN_1_se= 0.1763
          No_pT_1_se=0.1704
          No_dfi_1_se=0.2829
          No_metc_1_se=0.1770
          No_size_1_se=0.2309
          No_marg_1_se=0.2778
          No_age_1_se=0.1786

          
          
          #covariance
          No1_cov_b1_c1 <- -0.022655802
          No1_cov_b1_c2 <- -0.002625656
          No1_cov_b1_c3 <- -0.066777914
          No1_cov_b1_c4 <- -0.006973736
          No1_cov_b1_c5 <- -0.012670825
          No1_cov_b1_c6 <- -0.065044329
          No1_cov_b1_c7 <- -0.030490434
          No1_cov_c1_c2 <- -0.0057118938
          No1_cov_c1_c3 <- 0.0006319414
          No1_cov_c1_c4 <- 0.0003243108
          No1_cov_c1_c5 <- 0.0001502517
          No1_cov_c1_c6 <- 0.0009438652
          No1_cov_c1_c7 <- 0.0020692178
          No1_cov_c2_c3 <- -0.0061391128
          No1_cov_c2_c4 <- 0.0026993547
          No1_cov_c2_c5 <- -0.0004878635
          No1_cov_c2_c6 <- 0.0010097840
          No1_cov_c2_c7 <- 0.0001755245
          No1_cov_c3_c4 <- -0.0061440860
          No1_cov_c3_c5 <- 0.0077229285
          No1_cov_c3_c6 <- -0.0073020828
          No1_cov_c3_c7 <- 0.0045310768
          No1_cov_c4_c5 <- -0.0010778272
          No1_cov_c4_c6 <- 0.0003075654
          No1_cov_c4_c7 <- 0.0028484447
          No1_cov_c5_c6 <- -0.0025024534
          No1_cov_c5_c7 <- 0.0012547834
          No1_cov_c6_c7 <- 0.0010287673
          
          #Cov matrix
          V1_No <- matrix(c(
            No_coef_b1_se^2,   No1_cov_b1_c1,  No1_cov_b1_c2, No1_cov_b1_c3, No1_cov_b1_c4, No1_cov_b1_c5, No1_cov_b1_c6, No1_cov_b1_c7,
            No1_cov_b1_c1,  No_pN_1_se^2,  No1_cov_c1_c2, No1_cov_c1_c3, No1_cov_c1_c4, No1_cov_c1_c5, No1_cov_c1_c6, No1_cov_c1_c7,
            No1_cov_b1_c2,  No1_cov_c1_c2,  No_pT_1_se^2, No1_cov_c2_c3, No1_cov_c2_c4, No1_cov_c2_c5, No1_cov_c2_c6, No1_cov_c2_c7,
            No1_cov_b1_c3,  No1_cov_c1_c3, No1_cov_c2_c3, No_dfi_1_se^2,No1_cov_c3_c4,No1_cov_c3_c5, No1_cov_c3_c6, No1_cov_c3_c7,
            No1_cov_b1_c4, No1_cov_c1_c4,No1_cov_c2_c4,No1_cov_c3_c4,No_metc_1_se^2, No1_cov_c4_c5, No1_cov_c4_c6, No1_cov_c4_c7,
            No1_cov_b1_c5, No1_cov_c1_c5,No1_cov_c2_c5,No1_cov_c3_c5,No1_cov_c4_c5, No_size_1_se^2, No1_cov_c5_c6, No1_cov_c5_c7,
            No1_cov_b1_c6, No1_cov_c1_c6, No1_cov_c2_c6,No1_cov_c3_c6,No1_cov_c4_c6, No1_cov_c5_c6, No_marg_1_se^2, No1_cov_c6_c7,
            No1_cov_b1_c7, No1_cov_c1_c7, No1_cov_c2_c7, No1_cov_c3_c7, No1_cov_c4_c7, No1_cov_c5_c7,No1_cov_c6_c7, No_age_1_se^2
          ), nrow = 8, byrow = TRUE)
          
          
          
          #2 year
          coefs2 <- c(
            No_coef_b2=-1.2184,
            No_pN_2=0.5905 ,
            No_pT_2=0.3374,
            No_dfi_2=0.2645,
            No_metc_2=1.0317,
            No_size_2=0.1280,
            No_marg_2=0.5790,
            No_age_2=0.1368)

          
          #se
          No_coef_b2_se=0.3828
            No_pN_2_se=0.1737 
            No_pT_2_se=0.1760
            No_dfi_2_se=0.2657
            No_metc_2_se=0.1906
            No_size_2_se=0.2362
            No_marg_2_se=0.2633
            No_age_2_se=0.1814
            
            
            
            #covariance
            No2_cov_b1_c1 <- -0.020405201
            No2_cov_b1_c2 <- -0.002660911
            No2_cov_b1_c3 <- -0.056135951
            No2_cov_b1_c4 <- -0.006228669
            No2_cov_b1_c5 <- -0.013266078
            No2_cov_b1_c6 <- -0.056613549
            No2_cov_b1_c7 <- -0.030355354
            No2_cov_c1_c2 <- -6.022490e-03
            No2_cov_c1_c3 <- 9.102992e-05
            No2_cov_c1_c4 <- 1.619196e-04
            No2_cov_c1_c5 <- 6.345037e-04
            No2_cov_c1_c6 <- 1.100917e-03
            No2_cov_c1_c7 <- 1.843067e-03
            No2_cov_c2_c3 <- -0.0064469159
            No2_cov_c2_c4 <- 0.0025433967
            No2_cov_c2_c5 <- -0.0007210423
            No2_cov_c2_c6 <- 0.0014189837
            No2_cov_c2_c7 <- 0.0002685354
            No2_cov_c3_c4 <- -6.520310e-03
            No2_cov_c3_c5 <- 7.569579e-03
            No2_cov_c3_c6 <- -7.875105e-03
            No2_cov_c3_c7 <- 4.216620e-03
            No2_cov_c4_c5 <- -0.0008920444
            No2_cov_c4_c6 <- 0.0005406843
            No2_cov_c4_c7 <- 0.0026642066
            No2_cov_c5_c6 <- -0.0021460283
            No2_cov_c5_c7 <- 0.0012094833
            No2_cov_c6_c7 <- 0.0008586515
            
            #Cov matrix
            V2_No <- matrix(c(
              No_coef_b2_se^2,   No2_cov_b1_c1,  No2_cov_b1_c2, No2_cov_b1_c3, No2_cov_b1_c4, No2_cov_b1_c5, No2_cov_b1_c6, No2_cov_b1_c7,
              No2_cov_b1_c1,  No_pN_2_se^2,  No2_cov_c1_c2, No2_cov_c1_c3, No2_cov_c1_c4, No2_cov_c1_c5, No2_cov_c1_c6, No2_cov_c1_c7,
              No2_cov_b1_c2,  No2_cov_c1_c2,  No_pT_2_se^2, No2_cov_c2_c3, No2_cov_c2_c4, No2_cov_c2_c5, No2_cov_c2_c6, No2_cov_c2_c7,
              No2_cov_b1_c3,  No2_cov_c1_c3, No2_cov_c2_c3, No_dfi_2_se^2,No2_cov_c3_c4,No2_cov_c3_c5, No2_cov_c3_c6, No2_cov_c3_c7,
              No2_cov_b1_c4, No2_cov_c1_c4,No2_cov_c2_c4,No2_cov_c3_c4,No_metc_2_se^2, No2_cov_c4_c5, No2_cov_c4_c6, No2_cov_c4_c7,
              No2_cov_b1_c5, No2_cov_c1_c5,No2_cov_c2_c5,No2_cov_c3_c5,No2_cov_c4_c5, No_size_2_se^2, No2_cov_c5_c6, No2_cov_c5_c7,
              No2_cov_b1_c6, No2_cov_c1_c6, No2_cov_c2_c6,No2_cov_c3_c6,No2_cov_c4_c6, No2_cov_c5_c6, No_marg_2_se^2, No2_cov_c6_c7,
              No2_cov_b1_c7, No2_cov_c1_c7, No2_cov_c2_c7, No2_cov_c3_c7, No2_cov_c4_c7, No2_cov_c5_c7,No2_cov_c6_c7, No_age_2_se^2
            ), nrow = 8, byrow = TRUE)

          
          #3 year
          coefs3 <- c(
            No_coef_b3=-0.9004,
            No_pN_3= 0.6054,
            No_pT_3=0.3090,
            No_dfi_3=0.1330,
            No_metc_3=1.1423,
            No_size_3=0.1203,
            No_marg_3=0.5581,
            No_age_3=0.1934)
          
          
          
          
          #se
          No_coef_b3_se=0.4014
            No_pN_3_se=0.1817 
            No_pT_3_se=0.1871
            No_dfi_3_se=0.2801
            No_metc_3_se=0.2080
            No_size_3_se=0.2482
            No_marg_3_se=0.2744
            No_age_3_se=0.1917
            
            
            
            #covariance
            No3_cov_b1_c1 <- -0.023041289
            No3_cov_b1_c2 <- -0.002233316
            No3_cov_b1_c3 <- -0.062414877
            No3_cov_b1_c4 <- -0.006957602
            No3_cov_b1_c5 <- -0.016342400
            No3_cov_b1_c6 <- -0.060694402
            No3_cov_b1_c7 <- -0.034653001
            No3_cov_c1_c2 <- -0.0069360953
            No3_cov_c1_c3 <- 0.0007223092
            No3_cov_c1_c4 <- 0.0005357938
            No3_cov_c1_c5 <- 0.0011146413
            No3_cov_c1_c6 <- 0.0016105955
            No3_cov_c1_c7 <- 0.0022946135
            No3_cov_c2_c3 <- -0.0073017283
            No3_cov_c2_c4 <- 0.0023365946
            No3_cov_c2_c5 <- -0.0013893742
            No3_cov_c2_c6 <- 0.0010565836
            No3_cov_c2_c7 <- 0.0007729656
            No3_cov_c3_c4 <- -0.0073960634
            No3_cov_c3_c5 <- 0.0095196630
            No3_cov_c3_c6 <- -0.0096798479
            No3_cov_c3_c7 <- 0.0048937251
            No3_cov_c4_c5 <- -0.0010051385
            No3_cov_c4_c6 <- 0.0008202424
            No3_cov_c4_c7 <- 0.0032979241
            No3_cov_c5_c6 <- -0.001849507
            No3_cov_c5_c7 <- 0.001357912
            No3_cov_c6_c7 <- 0.0012386514
            
            #Cov matrix
            V3_No <- matrix(c(
              No_coef_b3_se^2,   No3_cov_b1_c1,  No3_cov_b1_c2, No3_cov_b1_c3, No3_cov_b1_c4, No3_cov_b1_c5, No3_cov_b1_c6, No3_cov_b1_c7,
              No3_cov_b1_c1,  No_pN_3_se^2,  No3_cov_c1_c2, No3_cov_c1_c3, No3_cov_c1_c4, No3_cov_c1_c5, No3_cov_c1_c6, No3_cov_c1_c7,
              No3_cov_b1_c2,  No3_cov_c1_c2,  No_pT_3_se^2, No3_cov_c2_c3, No3_cov_c2_c4, No3_cov_c2_c5, No3_cov_c2_c6, No3_cov_c2_c7,
              No3_cov_b1_c3,  No3_cov_c1_c3, No3_cov_c2_c3, No_dfi_3_se^2,No3_cov_c3_c4,No3_cov_c3_c5, No3_cov_c3_c6, No3_cov_c3_c7,
              No3_cov_b1_c4, No3_cov_c1_c4,No3_cov_c2_c4,No3_cov_c3_c4,No_metc_3_se^2, No3_cov_c4_c5, No3_cov_c4_c6, No3_cov_c4_c7,
              No3_cov_b1_c5, No3_cov_c1_c5,No3_cov_c2_c5,No3_cov_c3_c5,No3_cov_c4_c5, No_size_3_se^2, No3_cov_c5_c6, No3_cov_c5_c7,
              No3_cov_b1_c6, No3_cov_c1_c6, No3_cov_c2_c6,No3_cov_c3_c6,No3_cov_c4_c6, No3_cov_c5_c6, No_marg_3_se^2, No3_cov_c6_c7,
              No3_cov_b1_c7, No3_cov_c1_c7, No3_cov_c2_c7, No3_cov_c3_c7, No3_cov_c4_c7, No3_cov_c5_c7,No3_cov_c6_c7, No_age_3_se^2
            ), nrow = 8, byrow = TRUE)

          
          #1 year
          y_hat_No1  <- sum(X_No * coefs1)
          se_hat_No1 <- sqrt(t(X_No) %*% V1_No %*% X_No)
          ci_lower1 <- y_hat_No1 - 1.96 * se_hat_No1
          ci_upper1 <- y_hat_No1 + 1.96 * se_hat_No1
          
          mean1=plogis(y_hat_No1)*100
          CI_lower1=plogis(ci_lower1)*100
          CI_upper1=plogis(ci_upper1)*100
          
          
          
          #2 year
          y_hat_No2  <- sum(X_No * coefs2)
          se_hat_No2 <- sqrt(t(X_No) %*% V2_No %*% X_No)
          ci_lower2 <- y_hat_No2 - 1.96 * se_hat_No2
          ci_upper2 <- y_hat_No2 + 1.96 * se_hat_No2
          
          mean2=plogis(y_hat_No2)*100
          CI_lower2=plogis(ci_lower2)*100
          CI_upper2=plogis(ci_upper2)*100
          
          #3 year
          y_hat_No3  <- sum(X_No * coefs3)
          se_hat_No3 <- sqrt(t(X_No) %*% V3_No %*% X_No)
          ci_lower3 <- y_hat_No3 - 1.96 * se_hat_No3
          ci_upper3 <- y_hat_No3 + 1.96 * se_hat_No3
          
          mean3=plogis(y_hat_No3)*100
          CI_lower3=plogis(ci_lower3)*100
          CI_upper3=plogis(ci_upper3)*100
          
          data <- data.frame(RelapseRisk=c('1-year', '2-year', '3-year'),
                             Mean=c(mean1, mean2, mean3),
                             CI_lower=c(CI_lower1, CI_lower2, CI_lower3),
                             CI_upper=c(CI_upper1, CI_upper2, CI_upper3))
          
          p <- barplot(
            height = data$Mean,col = post_colors,
            ylim = c(0, 100),
            border = NA,       
            ylab = "RISK OF RELAPSE (%)",
            cex.names = 1.2,   # size of x-axis labels
            cex.lab = 1.2,     # size of y-axis label
            main = ""          # title
          )
          
          # Add error bars
          arrows(
            x0 = p,
            y0 = data$CI_lower,
            x1 = p,
            y1 = data$CI_upper,
            angle = 90,
            code = 3,
            length = 0.1,
            lwd = 1.5
          )
          
          
          axis(1, at = p, labels = data$RelapseRisk, tick = FALSE)
        })
        output$N_score <- renderText({
          
          marg_val <- numericMargin()
          if (is.na(marg_val)) return(NULL)
          
          stage_val <- numericStage()
          if (is.na(stage_val)) return(NULL)
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          age_val <- numericAge()
          if (is.na(age_val)) return(NULL)
          
          Nordlinger_score = ifelse(input$node>0, 1,0)+ifelse(dfi_val<24,1,0)+
            ifelse(stage_val>3,1,0)+ifelse(met_val>3, 1, 0)+
            ifelse(marg_val<10,1, 0)+ifelse(age_val>60,1,0)+ifelse(size_val>50, 1, 0)
          
          # 3 year relapse risk
          coefs3 <- c(
            No_coef_b3=-0.9004,
            No_pN_3= 0.6054,
            No_pT_3=0.3090,
            No_dfi_3=0.1330,
            No_metc_3=1.1423,
            No_size_3=0.1203,
            No_marg_3=0.5581,
            No_age_3=0.1934)
          
          X_No <- c(1,
                    ifelse(input$node>0, 1,0),
                    ifelse(stage_val>3,1,0),
                    ifelse(dfi_val<24,1,0),
                    ifelse(met_val>3, 1, 0),
                    ifelse(size_val>50, 1, 0),
                    ifelse(marg_val<10,1, 0),
                    ifelse(age_val>60,1,0))
          
          y_hat_No3  <- sum(X_No * coefs3)

          mean3_N=round(plogis(y_hat_No3)*100)
        
          HTML(paste0("<h3>", "Nordlinger score: ", '<span class=" h3 text-primary">', Nordlinger_score, '</span>',
                      "<h5>", "3-year estimated relapse risk: ", '<span class=" h2 text-primary">', mean3_N, "%",'</span>',
                      "<br>",
                      "<br>",
                      "<br>",
                      
                      '<h6><i>Low risk: 0-2<br>
                      Moderate risk: 3-4<br>
                      High risk: 5-7
                      <i></h6>'
          ))
          
        })
          

      
        
        
        # Nagashima 2006
        
        
        output$Na06_distPlot <- renderPlot({
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          stage_val <- numericStage()
          if (is.na(stage_val)) return(NULL)
          
          
          # generate bins based on input$bins from ui.R
          Na_score = 0.60034*ifelse(input$node>0, 1,0)+0.67838*ifelse(dfi_val<12,1,0)+
            0.54877*ifelse(stage_val>3,1,0)+0.85412*ifelse(met_val>1, 1, 0)+
            1.35657*ifelse(size_val>50, 1, 0)+1.19430*as.numeric(input$ResExtrahepMets)

          # knots
          t1 <- 0.60034
          t2 <- 1.53250
          t3 <- 2.13284
          t4 <- 3.87591
          
          scale <- (t4 - t1)^2
          
          # First spline term (Score_Na2006')
          pos <- function(x) ifelse(x > 0, x, 0)
          
          
          Na_sp1 <- pos(Na_score - t1)^3 - pos(Na_score - t3)^3 * (t4 - t1) / (t4 - t3) + pos(Na_score - t4)^3 * (t3 - t1) / (t4 - t3)
          Na_sp1_sc <- Na_sp1/scale
          
          # Second spline term (Score_Na2006'')
          Na_sp2 <- pos(Na_score - t2)^3 -
            pos(Na_score - t3)^3 * (t4 - t2) / (t4 - t3) +
            pos(Na_score - t4)^3 * (t3 - t2) / (t4 - t3)
          
          Na_sp2_sc <- Na_sp2/scale

          X_Na <- c(1, Na_score, Na_sp1_sc, Na_sp2_sc)
          
          
          #1 year
          coefs1 <- c(
          Na06_coef_b1 =-1.5362,
          Na06_coef_1_1=0.7895,
          Na06_coef_1_2=0.0228,
          Na06_coef_1_3=-1.5500)
          #se
          Na06_coef_b1_se <-0.3600
          Na06_coef_1_1_se <- 0.3467
          Na06_coef_1_2_se <- 1.6024
          Na06_coef_1_3_se <- 5.3122
          
          # covariance
          Na1_cov_b1_c1 <- -0.1147962
          Na1_cov_b1_c2 <- 0.4071772
          Na1_cov_b1_c3 <- -1.1980844
          Na1_cov_c1_c2 <- -0.5036527
          Na1_cov_c1_c3 <- 1.5562835
          Na1_cov_c2_c3 <- -8.4199718
          
          #Cov matrix
          V1_Na <- matrix(c(
            Na06_coef_b1_se^2,   Na1_cov_b1_c1,  Na1_cov_b1_c2, Na1_cov_b1_c3,
            Na1_cov_b1_c1,  Na06_coef_1_1_se^2,  Na1_cov_c1_c2, Na1_cov_c1_c3,
            Na1_cov_b1_c2,  Na1_cov_c1_c2,  Na06_coef_1_2_se^2, Na1_cov_c2_c3,
            Na1_cov_b1_c3,  Na1_cov_c1_c3, Na1_cov_c2_c3, Na06_coef_1_3_se^2
          ), nrow = 4, byrow = TRUE)
          
          
          
          #2 year
          coefs2 <- c(
          Na06_coef_b2= -1.0354,
          Na06_coef_2_1= 0.9860,
          Na06_coef_2_2=1.6170,
          Na06_coef_2_3=4.2896)
          #se
          Na06_coef_b2_se <- 0.3209
          Na06_coef_2_1_se <- 0.3210
          Na06_coef_2_2_se <- 1.5712
          Na06_coef_2_3_se <- 5.3235
          
          # covariance
          Na2_cov_b1_c1 <- -0.09359775
          Na2_cov_b1_c2 <-0.34395937
          Na2_cov_b1_c3 <- -1.02650283
          Na2_cov_c1_c2 <- -0.45394732
          Na2_cov_c1_c3 <- 1.42625771
          Na2_cov_c2_c3 <- -8.2630897
          
          #Cov matrix
          V2_Na <- matrix(c(
            Na06_coef_b2_se^2,   Na2_cov_b1_c1,  Na2_cov_b1_c2, Na2_cov_b1_c3,
            Na2_cov_b1_c1,  Na06_coef_2_1_se^2,  Na2_cov_c1_c2, Na2_cov_c1_c3,
            Na2_cov_b1_c2,  Na2_cov_c1_c2,  Na06_coef_2_2_se^2, Na2_cov_c2_c3,
            Na2_cov_b1_c3,  Na2_cov_c1_c3, Na2_cov_c2_c3, Na06_coef_2_3_se^2
          ), nrow = 4, byrow = TRUE)
          
          #3 year
          coefs3 <- c(
          Na06_coef_b3=-0.9323,
          Na06_coef_3_1= 1.1368,
          Na06_coef_3_2= -2.1984,
          Na06_coef_3_3= 5.9848)
          #se
          Na06_coef_b3_se <-0.3259
          Na06_coef_3_1_se <- 0.3312
          Na06_coef_3_2_se <- 1.6472
          Na06_coef_3_3_se <- 5.6064
          
          # covariance
          Na3_cov_b1_c1 <- -0.09772313
          Na3_cov_b1_c2 <- 0.36412318
          Na3_cov_b1_c3 <- -1.09162021
          Na3_cov_c1_c2 <- -0.49064021
          Na3_cov_c1_c3 <- 1.54789354
          Na3_cov_c2_c3 <- -9.1221438
          
          #Cov matrix
          V3_Na <- matrix(c(
            Na06_coef_b3_se^2,   Na3_cov_b1_c1,  Na3_cov_b1_c2, Na3_cov_b1_c3,
            Na3_cov_b1_c1,  Na06_coef_3_1_se^2,  Na3_cov_c1_c2, Na3_cov_c1_c3,
            Na3_cov_b1_c2,  Na3_cov_c1_c2,  Na06_coef_3_2_se^2, Na3_cov_c2_c3,
            Na3_cov_b1_c3,  Na3_cov_c1_c3, Na3_cov_c2_c3, Na06_coef_3_3_se^2
          ), nrow = 4, byrow = TRUE)
          
          #1 year risk
          y_hat_Na1  <- sum(X_Na * coefs1)
          se_hat_Na1 <- sqrt(t(X_Na) %*% V1_Na %*% X_Na)
          ci_lower1 <- y_hat_Na1 - 1.96 * se_hat_Na1
          ci_upper1 <- y_hat_Na1 + 1.96 * se_hat_Na1
          
          mean1=plogis(y_hat_Na1)*100
          CI_lower1=plogis(ci_lower1)*100
          CI_upper1=plogis(ci_upper1)*100
          
          
          
          #2 year
          y_hat_Na2  <- sum(X_Na * coefs2)
          se_hat_Na2 <- sqrt(t(X_Na) %*% V2_Na %*% X_Na)
          ci_lower2 <- y_hat_Na2 - 1.96 * se_hat_Na2
          ci_upper2 <- y_hat_Na2 + 1.96 * se_hat_Na2
          
          mean2=plogis(y_hat_Na2)*100
          CI_lower2=plogis(ci_lower2)*100
          CI_upper2=plogis(ci_upper2)*100
          
          #3 year
          y_hat_Na3  <- sum(X_Na * coefs3)
          se_hat_Na3 <- sqrt(t(X_Na) %*% V3_Na %*% X_Na)
          ci_lower3 <- y_hat_Na3 - 1.96 * se_hat_Na3
          ci_upper3 <- y_hat_Na3 + 1.96 * se_hat_Na3
          
          mean3=plogis(y_hat_Na3)*100
          CI_lower3=plogis(ci_lower3)*100
          CI_upper3=plogis(ci_upper3)*100
          
          
          
          data <- data.frame(RelapseRisk=c('1-year', '2-year', '3-year'),
                             Mean=c(mean1, mean2, mean3),
                             CI_lower=c(CI_lower1, CI_lower2, CI_lower3),
                             CI_upper=c(CI_upper1, CI_upper2, CI_upper3))
          
          p <- barplot(
            height = data$Mean,
            col = colors,
            ylim = c(0, 100),
            border = NA,
            ylab = "RISK OF RELAPSE (%)",
            cex.names = 1.2, 
            cex.lab = 1.2, 
            main = "" 
          )
          
          # Add error bars
          # Vertical line
          segments(
            x0 = p, y0 = data$CI_lower,
            x1 = p, y1 = data$CI_upper,
            lwd = 1.5
          )
          
          # Top cap
          segments(
            x0 = p - 0.05, y0 = data$CI_upper,
            x1 = p + 0.05, y1 = data$CI_upper,
            lwd = 1.5
          )
          
          # Bottom cap
          segments(
            x0 = p - 0.05, y0 = data$CI_lower,
            x1 = p + 0.05, y1 = data$CI_lower,
            lwd = 1.5
          )
          
          
          axis(1, at = p, labels = data$RelapseRisk, tick = FALSE)
        })
        output$Na06_score <- renderText({
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          stage_val <- numericStage()
          if (is.na(stage_val)) return(NULL)
          
          
          
          Na_score = 0.60034*ifelse(input$node>0, 1,0)+0.67838*ifelse(dfi_val<12,1,0)+
            0.54877*ifelse(stage_val>3,1,0)+0.85412*ifelse(met_val>1, 1, 0)+
            1.35657*ifelse(size_val>50, 1, 0)+1.19430*as.numeric(input$ResExtrahepMets)
          
          # knots
          t1 <- 0.60034
          t2 <- 1.53250
          t3 <- 2.13284
          t4 <- 3.87591
          
          scale <- (t4 - t1)^2
          
          # First spline term (Score_Na2006')
          pos <- function(x) ifelse(x > 0, x, 0)
          
          
          Na_sp1 <- pos(Na_score - t1)^3 - pos(Na_score - t3)^3 * (t4 - t1) / (t4 - t3) + pos(Na_score - t4)^3 * (t3 - t1) / (t4 - t3)
          Na_sp1_sc <- Na_sp1/scale
          
          # Second spline term (Score_Na2006'')
          Na_sp2 <- pos(Na_score - t2)^3 -
            pos(Na_score - t3)^3 * (t4 - t2) / (t4 - t3) +
            pos(Na_score - t4)^3 * (t3 - t2) / (t4 - t3)
          
          Na_sp2_sc <- Na_sp2/scale
          
          X_Na <- c(1, Na_score, Na_sp1_sc, Na_sp2_sc)
          
          #3 year
          coefs3 <- c(
            Na06_coef_b3=-0.9323,
            Na06_coef_3_1= 1.1368,
            Na06_coef_3_2= -2.1984,
            Na06_coef_3_3= 5.9848)
          
          #3 year risk
          y_hat_Na3  <- sum(X_Na * coefs3)
          mean3_Na06=round(plogis(y_hat_Na3)*100)

          
          HTML(paste0("<h3>", "Nagashima score: ", '<span class=" h3 text-primary">', round(Na_score,2), '</span>',
                      "<h5>", "3-year estimated relapse risk: ", '<span class=" h2 text-primary">', mean3_Na06, "%",'</span>',
                      "<br>",
                      "<br>",
                      "<br>",
                      
                      '<h6><i>Low risk: ≤3<br>
                      Moderate risk: 3-5<br>
                      High risk: >5
                      <i></h6>'
          ))
          
        })

        
        # GAME
        
        output$GAME_distPlot <- renderPlot({
          
          
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          cea_val <- numericCEA()
          if (is.na(cea_val)) return(NULL)
          
          ras_val <- numericRAS()
          if (is.na(ras_val)) return(NULL)
          
          #tumor burden
          TBS <- sqrt(((size_val/10)^2)+(met_val^2))
          print(paste("TBS is",TBS, sep = ' '))
          
          # generate bins based on input$bins from ui.R
          
          
          X_G <- c(1,
                   ifelse(ras_val>1, 1,0),
                   ifelse(cea_val>20,1,0),
                   ifelse(input$node>0, 1,0),
                   ifelse(TBS>=3 & TBS<9, 1, 0),
                   ifelse(TBS>=9, 1, 0),
                   as.numeric(input$ResExtrahepMets))
          
          
          #1 year
          coefs1 <- c(
          G_coef_b1 =-1.3878,
          G_kras_1 = 0.2255,
          G_cea_1 = 0.3401,
          G_pN_1 = 0.7891,
          G_tbs1_1 = 0.4788,
          G_tbs2_1 = 1.4248,
          G_eheps_1 = 0.7408)
          
          #1 year se
          G_coef_b1_se <-0.2135
          G_kras_1_se <- 0.1599
          G_cea_1_se <- 0.1814
          G_pN_1_se <- 0.1741
          G_tbs1_1_se <- 0.1790
          G_tbs2_1_se <- 0.2597
          G_eheps_1_se <- 0.2146
          
          #covariance
          G1_cov_b1_c1 <- -0.010823277
          G1_cov_b1_c2 <- -0.007360234
          G1_cov_b1_c3 <- -0.022656367
          G1_cov_b1_c4 <- -0.021576750
          G1_cov_b1_c5 <- -0.023675602
          G1_cov_b1_c6 <- -0.009876103
          G1_cov_c1_c2 <- 0.0002013423
          G1_cov_c1_c3 <- -0.0012949615
          G1_cov_c1_c4 <- 0.0004628323
          G1_cov_c1_c5 <- 0.0017417480
          G1_cov_c1_c6 <- 0.0001557994
          G1_cov_c2_c3 <- 1.545119e-03
          G1_cov_c2_c4 <- -3.061079e-03
          G1_cov_c2_c5 <- -5.769342e-03
          G1_cov_c2_c6 <- -4.533261e-05
          G1_cov_c3_c4 <- 0.0016911781
          G1_cov_c3_c5 <- 0.0038559597
          G1_cov_c3_c6 <- 0.0005454801
          G1_cov_c4_c5 <- 0.0212128471
          G1_cov_c4_c6 <- 0.0023804321
          G1_cov_c5_c6 <- 0.004255455
          
          #Cov matrix
          V1_G <- matrix(c(
            G_coef_b1_se^2,   G1_cov_b1_c1,  G1_cov_b1_c2, G1_cov_b1_c3, G1_cov_b1_c4, G1_cov_b1_c5, G1_cov_b1_c6,
            G1_cov_b1_c1,  G_kras_1_se^2,  G1_cov_c1_c2, G1_cov_c1_c3, G1_cov_c1_c4, G1_cov_c1_c5, G1_cov_c1_c6,
            G1_cov_b1_c2,  G1_cov_c1_c2,  G_cea_1_se^2, G1_cov_c2_c3, G1_cov_c2_c4, G1_cov_c2_c5, G1_cov_c2_c6,
            G1_cov_b1_c3,  G1_cov_c1_c3, G1_cov_c2_c3, G_pN_1_se^2,G1_cov_c3_c4,G1_cov_c3_c5, G1_cov_c3_c6,
            G1_cov_b1_c4, G1_cov_c1_c4,G1_cov_c2_c4,G1_cov_c3_c4,G_tbs1_1_se^2, G1_cov_c4_c5, G1_cov_c4_c6,
            G1_cov_b1_c5, G1_cov_c1_c5,G1_cov_c2_c5,G1_cov_c3_c5,G1_cov_c4_c5, G_tbs2_1_se^2, G1_cov_c5_c6,
            G1_cov_b1_c6, G1_cov_c1_c6, G1_cov_c2_c6,G1_cov_c3_c6,G1_cov_c4_c6, G1_cov_c5_c6, G_eheps_1_se^2
          ), nrow = 7, byrow = TRUE)
          
          
          #2 year
          coefs2 <- c(
          G_coef_b2 =-0.7997,
          G_kras_2 = 0.3599,
          G_cea_2 = 0.3588,
          G_pN_2 = 0.7028,
          G_tbs1_2 = 0.3424,
          G_tbs2_2 =1.4856,
          G_eheps_2 = 1.0371)
          
          #2 year se
          G_coef_b2_se <-0.2050
          G_kras_2_se <- 0.1652
          G_cea_2_se <- 0.1914
          G_pN_2_se <- 0.1732
          G_tbs1_2_se <- 0.1784
          G_tbs2_2_se <-0.2913
          G_eheps_2_se <- 0.2439
          
          #covariance
          G2_cov_b1_c1 <- -0.011082443
            G2_cov_b1_c2 <- -0.007120954
            G2_cov_b1_c3 <- -0.021098695
            G2_cov_b1_c4 <- -0.020541997
            G2_cov_b1_c5 <- -0.022465253
            G2_cov_b1_c6 <- -0.010205590
            G2_cov_c1_c2 <- 0.0002212754
            G2_cov_c1_c3 <- -0.0012173699
            G2_cov_c1_c4 <- 0.0004074205
            G2_cov_c1_c5 <- 0.0019210456
            G2_cov_c1_c6 <- 0.0002475013
            G2_cov_c2_c3 <- 1.047113e-03
            G2_cov_c2_c4 <- -3.390919e-03
            G2_cov_c2_c5 <- -6.538220e-03
            G2_cov_c2_c6 <- -6.635323e-05
            G2_cov_c3_c4 <- 0.001625889
            G2_cov_c3_c5 <- 0.003685109
            G2_cov_c3_c6 <- 0.000797353
            G2_cov_c4_c5 <- 0.0204360788
            G2_cov_c4_c6 <- 0.0026337652
            G2_cov_c5_c6 <- 0.004766703
            
            #Cov matrix
            V2_G <- matrix(c(
              G_coef_b2_se^2,   G2_cov_b1_c1,  G2_cov_b1_c2, G2_cov_b1_c3, G2_cov_b1_c4, G2_cov_b1_c5, G2_cov_b1_c6,
              G2_cov_b1_c1,  G_kras_2_se^2,  G2_cov_c1_c2, G2_cov_c1_c3, G2_cov_c1_c4, G2_cov_c1_c5, G2_cov_c1_c6,
              G2_cov_b1_c2,  G2_cov_c1_c2,  G_cea_2_se^2, G2_cov_c2_c3, G2_cov_c2_c4, G2_cov_c2_c5, G2_cov_c2_c6,
              G2_cov_b1_c3,  G2_cov_c1_c3, G2_cov_c2_c3, G_pN_2_se^2,G2_cov_c3_c4,G2_cov_c3_c5, G2_cov_c3_c6,
              G2_cov_b1_c4, G2_cov_c1_c4,G2_cov_c2_c4,G2_cov_c3_c4,G_tbs1_2_se^2, G2_cov_c4_c5, G2_cov_c4_c6,
              G2_cov_b1_c5, G2_cov_c1_c5,G2_cov_c2_c5,G2_cov_c3_c5,G2_cov_c4_c5, G_tbs2_2_se^2, G2_cov_c5_c6,
              G2_cov_b1_c6, G2_cov_c1_c6, G2_cov_c2_c6,G2_cov_c3_c6,G2_cov_c4_c6, G2_cov_c5_c6, G_eheps_2_se^2
            ), nrow = 7, byrow = TRUE)
          
          #3 year
            coefs3 <- c(
          G_coef_b3 =-0.5858,
          G_kras_3=0.3880,
          G_cea_3=0.2063,
          G_pN_3=0.6862,
          G_tbs1_3=0.4537,
          G_tbs2_3=1.5930,
          G_eheps_3=1.0428)
            
          #3 year se
          G_coef_b3_se <-0.2087
          G_kras_3_se <-0.1748 
          G_cea_3_se <- 0.1995
          G_pN_3_se <- 0.1803
          G_tbs1_3_se <- 0.1861
          G_tbs2_3_se <- 0.3141
          G_eheps_3_se <- 0.2633
          
          #covariance
          G3_cov_b1_c1 <- -0.011495448
            G3_cov_b1_c2 <- -0.007304233
            G3_cov_b1_c3 <- -0.022019664
            G3_cov_b1_c4 <- -0.021655715
            G3_cov_b1_c5 <- -0.023651216
            G3_cov_b1_c6 <- -0.010808375
            G3_cov_c1_c2 <- -0.0000799008
            G3_cov_c1_c3 <- -0.0018680992
            G3_cov_c1_c4 <- 0.0004445813
            G3_cov_c1_c5 <- 0.0021825548
            G3_cov_c1_c6 <- -0.0002970485
            G3_cov_c2_c3 <- 0.0009200139
            G3_cov_c2_c4 <- -0.0043916893
            G3_cov_c2_c5 <- -0.0081638100
            G3_cov_c2_c6 <- -0.0005351744
            G3_cov_c3_c4 <- 0.0016964274
            G3_cov_c3_c5 <- 0.0039934713
            G3_cov_c3_c6 <- 0.0007032613
            G3_cov_c4_c5 <- 0.0219572140
            G3_cov_c4_c6 <- 0.0031699385
            G3_cov_c5_c6 <- 0.005233458
            
            #Cov matrix
            V3_G <- matrix(c(
              G_coef_b3_se^2,   G3_cov_b1_c1,  G3_cov_b1_c2, G3_cov_b1_c3, G3_cov_b1_c4, G3_cov_b1_c5, G3_cov_b1_c6,
              G3_cov_b1_c1,  G_kras_3_se^2,  G3_cov_c1_c2, G3_cov_c1_c3, G3_cov_c1_c4, G3_cov_c1_c5, G3_cov_c1_c6,
              G3_cov_b1_c2,  G3_cov_c1_c2,  G_cea_3_se^2, G3_cov_c2_c3, G3_cov_c2_c4, G3_cov_c2_c5, G3_cov_c2_c6,
              G3_cov_b1_c3,  G3_cov_c1_c3, G3_cov_c2_c3, G_pN_3_se^2,G3_cov_c3_c4,G3_cov_c3_c5, G3_cov_c3_c6,
              G3_cov_b1_c4, G3_cov_c1_c4,G3_cov_c2_c4,G3_cov_c3_c4,G_tbs1_3_se^2, G3_cov_c4_c5, G3_cov_c4_c6,
              G3_cov_b1_c5, G3_cov_c1_c5,G3_cov_c2_c5,G3_cov_c3_c5,G3_cov_c4_c5, G_tbs2_3_se^2, G3_cov_c5_c6,
              G3_cov_b1_c6, G3_cov_c1_c6, G3_cov_c2_c6,G3_cov_c3_c6,G3_cov_c4_c6, G3_cov_c5_c6, G_eheps_3_se^2
            ), nrow = 7, byrow = TRUE)
          
          #1 year
          y_hat_G1  <- sum(X_G * coefs1)
          se_hat_G1 <- sqrt(t(X_G) %*% V1_G %*% X_G)
          ci_lower1 <- y_hat_G1 - 1.96 * se_hat_G1
          ci_upper1 <- y_hat_G1 + 1.96 * se_hat_G1
          
          mean1=plogis(y_hat_G1)*100
          CI_lower1=plogis(ci_lower1)*100
          CI_upper1=plogis(ci_upper1)*100

          #2 year
          y_hat_G2  <- sum(X_G * coefs2)
          se_hat_G2 <- sqrt(t(X_G) %*% V2_G %*% X_G)
          ci_lower2 <- y_hat_G2 - 1.96 * se_hat_G2
          ci_upper2 <- y_hat_G2 + 1.96 * se_hat_G2
          
          mean2=plogis(y_hat_G2)*100
          CI_lower2=plogis(ci_lower2)*100
          CI_upper2=plogis(ci_upper2)*100
          
          #3 year
          y_hat_G3  <- sum(X_G * coefs3)
          se_hat_G3 <- sqrt(t(X_G) %*% V3_G %*% X_G)
          ci_lower3 <- y_hat_G3 - 1.96 * se_hat_G3
          ci_upper3 <- y_hat_G3 + 1.96 * se_hat_G3
          
          mean3=plogis(y_hat_G3)*100
          CI_lower3=plogis(ci_lower3)*100
          CI_upper3=plogis(ci_upper3)*100
          
          data <- data.frame(RelapseRisk=c('1-year', '2-year', '3-year'),
                             Mean=c(mean1, mean2, mean3),
                             CI_lower=c(CI_lower1, CI_lower2, CI_lower3),
                             CI_upper=c(CI_upper1, CI_upper2, CI_upper3))
          
          
          p <- barplot(
            height = data$Mean,
            col = colors,
            ylim = c(0, 100),
            border = NA, 
            ylab = "RISK OF RELAPSE (%)",
            cex.names = 1.2,   # size of x-axis labels
            cex.lab = 1.2,     # size of y-axis label
            main = ""          # title
          )
          
          # Add error bars
          arrows(
            x0 = p,
            y0 = data$CI_lower,
            x1 = p,
            y1 = data$CI_upper,
            angle = 90,
            code = 3,
            length = 0.1,
            lwd = 1.5
          )
          
          axis(1, at = p, labels = data$RelapseRisk, tick = FALSE)
        })
        output$GAME_score <- renderText({
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          size_val <- numericSize()
          if (is.na(size_val)) return(NULL)
          
          cea_val <- numericCEA()
          if (is.na(cea_val)) return(NULL)
          
          ras_val <- numericRAS()
          if (is.na(ras_val)) return(NULL)
          
          TBS <- sqrt(((size_val/10)^2)+(met_val^2))
          print(paste("TBS_2 is",TBS, sep = ' '))
          
          
          
          GAME_score = ifelse(ras_val>1, 1,0)+ifelse(input$node>0, 1,0)+ifelse(TBS>=9, 2,
                                                        ifelse(TBS>=3 & TBS<9, 1, 0))+ ifelse(cea_val>20,1,0)+as.numeric(input$ResExtrahepMets)*2
          
          # 3 year relapse risk
          coefs3 <- c(
            G_coef_b3 =-0.5858,
            G_kras_3=0.3880,
            G_cea_3=0.2063,
            G_pN_3=0.6862,
            G_tbs1_3=0.4537,
            G_tbs2_3=1.5930,
            G_eheps_3=1.0428)

          X_G <- c(1,
                   ifelse(ras_val>1, 1,0),
                   ifelse(cea_val>20,1,0),
                   ifelse(input$node>0, 1,0),
                   ifelse(TBS>=3 & TBS<9, 1, 0),
                   ifelse(TBS>=9, 1, 0),
                   as.numeric(input$ResExtrahepMets))
          #3 year
          y_hat_G3  <- sum(X_G * coefs3)
          mean3_GAME=round(plogis(y_hat_G3)*100)

          
          HTML(paste0("<h3>", "GAME score: ", '<span class=" h3 text-primary">', round(GAME_score, 2), '</span>',
                      "<h5>", "3-year estimated relapse risk: ", '<span class=" h2 text-primary">', mean3_GAME, "%",'</span>',
                      "<br>",
                      #"<h5>", "95% confidence interval: ", '<span class=" h2 text-primary">', CI_lower3_GAME, "-", CI_upper3_GAME, "%",'</span>',
                      "<br>",
                      "<br>",
                      
                      '<h6><i>Low risk: 0-1<br>
                      Moderate risk: 2-3<br>
                      High risk: 4-7
                      <i></h6>'
          ))
          
          
        })
        
                

        # Konopke
        
        
        output$K_distPlot <- renderPlot({
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          cea_val <- numericCEA()
          if (is.na(cea_val)) return(NULL)
          

          
          # generate bins based on input$bins from ui.R
          # observation
          X_K <- c(1, ifelse(met_val>3, 1, 0),ifelse(cea_val>200,1,0), ifelse(dfi_val<=0,1,0))
     
          #1 year
          coefs1 <- c(
            K_coef_b1 =-0.5814,
            K_mcount_1 = 0.9654,
            K_cea_1 = -0.0529,
            K_sync_1 = 0.4151)
          
          #se
          K_coef_b1_se <-0.1244
          K_mcount_1_se <- 0.1727
          K_cea_1_se <- 0.3496
          K_sync_1_se <- 0.1581
          
          #covariance
          K1_cov_b1_c1 <- -0.006602825
          K1_cov_b1_c2 <- -0.006552327
          K1_cov_b1_c3 <- -0.012820171
          K1_cov_c1_c2 <- 0.001935729
          K1_cov_c1_c3 <- -0.003950623
          K1_cov_c2_c3 <- -0.0006867318
          
          #Cov matrix
          V1_K <- matrix(c(
            K_coef_b1_se^2,   K1_cov_b1_c1,  K1_cov_b1_c2, K1_cov_b1_c3,
            K1_cov_b1_c1,  K_mcount_1_se^2,  K1_cov_c1_c2, K1_cov_c1_c3,
            K1_cov_b1_c2,  K1_cov_c1_c2,  K_cea_1_se^2, K1_cov_c2_c3,
            K1_cov_b1_c3,  K1_cov_c1_c3, K1_cov_c2_c3, K_sync_1_se^2
          ), nrow = 4, byrow = TRUE)
          
          
          #2 year
          coefs2 <- c(
            K_coef_b2=-0.0012,
          K_mcount_2 = 0.9913,
          K_cea_2 = -0.0128,
          K_sync_2 = 0.3276)
          
          #se
          K_coef_b2_se <-0.1215
          K_mcount_2_se <- 0.1874
          K_cea_2_se <- 0.3530
          K_sync_2_se <- 0.1604
          
          #covariance
          K2_cov_b1_c1 <- -0.006209859
            K2_cov_b1_c2 <- -0.006835117
            K2_cov_b1_c3 <- -0.012527713
            K2_cov_c1_c2 <- 0.002102010
            K2_cov_c1_c3 <- -0.004430066
            K2_cov_c2_c3 <- -0.0005621673
            
            #Cov matrix
            V2_K <- matrix(c(
              K_coef_b2_se^2,   K2_cov_b1_c1,  K2_cov_b1_c2, K2_cov_b1_c3,
              K2_cov_b1_c1,  K_mcount_2_se^2,  K2_cov_c1_c2, K2_cov_c1_c3,
              K2_cov_b1_c2,  K2_cov_c1_c2,  K_cea_2_se^2, K2_cov_c2_c3,
              K2_cov_b1_c3,  K2_cov_c1_c3, K2_cov_c2_c3, K_sync_2_se^2
            ), nrow = 4, byrow = TRUE)
          
          #3 year
          coefs3 <- c(
          K_coef_b3 =0.1960,
          K_mcount_3 = 1.0741,
          K_cea_3 = -0.0112,
          K_sync_3 = 0.3824)
          
          #se
          K_coef_b3_se <-0.1259
          K_mcount_3_se <- 0.2050
          K_cea_3_se <- 0.3641
          K_sync_3_se <- 0.1691
          
          #covariance
          K3_cov_b1_c1 <- -0.006748489
            K3_cov_b1_c2 <- -0.007657463
            K3_cov_b1_c3 <- -0.013550825
            K3_cov_c1_c2 <- 0.002515812
            K3_cov_c1_c3 <- -0.004923581
            K3_cov_c2_c3 <- -0.0006014928
            
            #Cov matrix
            V3_K <- matrix(c(
              K_coef_b3_se^2,   K3_cov_b1_c1,  K3_cov_b1_c2, K3_cov_b1_c3,
              K3_cov_b1_c1,  K_mcount_3_se^2,  K3_cov_c1_c2, K3_cov_c1_c3,
              K3_cov_b1_c2,  K3_cov_c1_c2,  K_cea_3_se^2, K3_cov_c2_c3,
              K3_cov_b1_c3,  K3_cov_c1_c3, K3_cov_c2_c3, K_sync_3_se^2
            ), nrow = 4, byrow = TRUE)
          
          # 1 year relapse risk
          #1 year
          y_hat_K1  <- sum(X_K * coefs1)
          se_hat_K1 <- sqrt(t(X_K) %*% V1_K %*% X_K)
          ci_lower1 <- y_hat_K1 - 1.96 * se_hat_K1
          ci_upper1 <- y_hat_K1 + 1.96 * se_hat_K1
          
          mean1=plogis(y_hat_K1)*100
          CI_lower1=plogis(ci_lower1)*100
          CI_upper1=plogis(ci_upper1)*100
          
          #2 year
          y_hat_K2  <- sum(X_K * coefs2)
          se_hat_K2 <- sqrt(t(X_K) %*% V2_K %*% X_K)
          ci_lower2 <- y_hat_K2 - 1.96 * se_hat_K2
          ci_upper2 <- y_hat_K2 + 1.96 * se_hat_K2
          
          mean2=plogis(y_hat_K2)*100
          CI_lower2=plogis(ci_lower2)*100
          CI_upper2=plogis(ci_upper2)*100
          
          #3 year
          y_hat_K3  <- sum(X_K * coefs3)
          se_hat_K3 <- sqrt(t(X_K) %*% V3_K %*% X_K)
          ci_lower3 <- y_hat_K3 - 1.96 * se_hat_K3
          ci_upper3 <- y_hat_K3 + 1.96 * se_hat_K3
          
          mean3=plogis(y_hat_K3)*100
          CI_lower3=plogis(ci_lower3)*100
          CI_upper3=plogis(ci_upper3)*100
          
          data <- data.frame(RelapseRisk=c('1-year', '2-year', '3-year'),
                             Mean=c(mean1, mean2, mean3),
                             CI_lower=c(CI_lower1, CI_lower2, CI_lower3),
                             CI_upper=c(CI_upper1, CI_upper2, CI_upper3))
          
          # draw the histogram with the specified number of bins
          p <- barplot(
            height = data$Mean,
            col = colors,
            ylim = c(0, 100),
            border = NA,
            ylab = "RISK OF RELAPSE (%)",
            cex.names = 1.2,
            cex.lab = 1.2,
            main = ""
          )
          
          # Add error bars
          arrows(
            x0 = p,
            y0 = data$CI_lower,
            x1 = p,
            y1 = data$CI_upper,
            angle = 90,
            code = 3,
            length = 0.1,
            lwd = 1.5
          )
          
          axis(1, at = p, labels = data$RelapseRisk, tick = FALSE)
        })
        output$K_score <- renderText({
          
          met_val <- numericMetCount()
          if (is.na(met_val)) return(NULL)
          
          dfi_val <- numericDFI()
          if (is.na(dfi_val)) return(NULL)
          
          cea_val <- numericCEA()
          if (is.na(cea_val)) return(NULL)
          

          
          Konopke_score = ifelse(met_val>3, 1, 0)+ifelse(dfi_val<=0,1,0)+ifelse(cea_val>200,1,0)
          
          #3 year
          coefs3 <- c(
            K_coef_b3 =0.1960,
            K_mcount_3 = 1.0741,
            K_cea_3 = -0.0112,
            K_sync_3 = 0.3824)
          
          X_K <- c(1, ifelse(met_val>3, 1, 0),ifelse(cea_val>200,1,0), ifelse(dfi_val<=0,1,0))
          
          
          # 3 year relapse risk
          y_hat_K3  <- sum(X_K * coefs3)
          mean3_K=round(plogis(y_hat_K3)*100)
    
          HTML(paste0("<h3>", "Konopke score: ", '<span class=" h3 text-primary">', Konopke_score, '</span>',
                      "<h5>", "3-year estimated relapse risk: ", '<span class=" h2 text-primary">', mean3_K, "%",'</span>',
                      "<br>",
                      #"<h5>", "95% confidence interval: ", '<span class=" h2 text-primary">', CI_lower3_K, "-", CI_upper3_K, "%",'</span>',
                      "<br>",
                      "<br>",
                      
                      '<h6><i>Low risk: 1<br>
                      Moderate risk: 2<br>
                      High risk: 3
                      <i></h6>'
          ))
          
          
        })
        

        
# ----------------------- EXPLATORY PLOTS --------------------------------
        
        # colors
        #c <- c('#FC5C64FF','#FCCC4CFF','#146C94FF','#F5AA9DFF','#150C08FF') #paletteer; Steven
        #c <- c('#c090ae','#eee461','#3070ad','#dca342','#000000') #okabe and ito
        c <- c('#7d538f','#9786b1','#bcb0cf','#ddd6e1','#f6f6f7')
        c2 <- c('#3f8d5f','#76b189','#b7d1b8','#dbe6dd','#f6f6f7')
        
        # Helsinki
        HelRiskClass <- reactive({
          HRiskClass <- as.character(input$ScoreH)
          switch(HRiskClass,
                 "Low risk: 0-2" = 'ScoreH_0-2.txt',
                 "Moderate risk: 3-4" = 'ScoreH_3-4.txt',
                 "High risk: 5-8" = 'ScoreH_5-8.txt',
                 NA)  # fallback if input is NULL
        })
        
        observe({
          print(paste("Mapped file for Helsinki score risk class:", HelRiskClass()))
        })
        
        output$H_relps_title <- renderText({
          paste("<h4>", "Helsinki Score")
        })
        
        output$H_relps_text <- renderText({
          paste(
            "<h6>","Fraction of relapses in KaroLiver by the selected risk class", "<br><h6>",
            "0-2: Low risk","<br>", "3-4: Moderate risk", "<br>", "5-8: High risk")
        })
        
        
        output$H_relpsPlot <- renderPlot({
          
          HRiskClass_file <- HelRiskClass()
          if (is.na(HRiskClass_file)) return(NULL)
          
          ScoreH <- read.table(paste0("./data/",HRiskClass_file), sep=';', header = T)
          
          sample_size <- ifelse(HRiskClass_file=='ScoreH_0-2.txt', 71,
                                ifelse(HRiskClass_file=='ScoreH_3-4.txt', 280, 358))
          
          
          
          # Data
          vals <- ScoreH$fraction
          labs <- ScoreH$category
          cols <- c2 

          # Set clockwise orientation:
          vals_cw <- rev(vals)
          labs_cw <- rev(labs)
          cols_cw <- rev(cols)
          
          # Rotation mirror (degrees): 
          init_angle <- 250
          
          # --- Draw Donut ---
          par(mar = c(2,2,2,2))
          
          pie(vals_cw,
              labels = paste(labs_cw, ' ', round(vals_cw*100),'%', sep=''),
              clockwise = TRUE,
              init.angle = init_angle,
              radius = 1,
              col = cols_cw,
              border = NA
          )
          
          # Add white circle to create donut hole
          symbols(0, 0, circles = 0.5, inches = FALSE, add = TRUE, bg = "white", fg = "white")
          
          # Add center text (annotation)
          text(0, 0.05, paste("n =", sample_size),
               cex = 1.5, font = 2)
          
          
          
        })
        
        
        #m-CS
        mCS_RiskClass <- reactive({
          mCSRiskClass <- as.character(input$ScoremCS)
          switch(mCSRiskClass,
                 "Low risk: 0" = 'ScoremCS_Low.txt',
                 "Intermediate risk: 1" = 'ScoremCS_Intermediate.txt',
                 "Moderate risk: 2" = 'ScoremCS_Moderate.txt',
                 "High risk: 3" = 'ScoremCS_High.txt',
                 NA)  # fallback if input is NULL
        })
        
        observe({
          print(paste("Mapped file for m-CS score risk class:", mCS_RiskClass()))
        })
        
        output$mCS_relps_title <- renderText({
          paste("<h4>", "m-CS Score")
        })
        
        output$mCS_relps_text <- renderText({
          paste(
            "<h6>","Fraction of relapses in KaroLiver by the selected risk class", "<br><h6>",
            "0: Low risk","<br>", "1: Intermediate risk", "2: Moderate risk", "<br>", "3: High risk")
        })
        
        
        output$mCS_relpsPlot <- renderPlot({
          
          mCSRiskClass_file <- mCS_RiskClass()
          if (is.na(mCSRiskClass_file)) return(NULL)
          
          ScoremCS <- read.table(paste0("./data/",mCSRiskClass_file), sep=';', header = T)
          
          sample_size <- ifelse(mCSRiskClass_file=='ScoremCS_Low.txt', 106,
                                ifelse(mCSRiskClass_file=='ScoremCS_Intermediate.txt', 305,
                                       ifelse(mCSRiskClass_file=='ScoremCS_Moderate.txt', 264,34)))
          
          # Data
          vals <- ScoremCS$fraction
          labs <- ScoremCS$category
          cols <- c        
          
          
          vals_cw <- rev(vals)
          labs_cw <- rev(labs)
          cols_cw <- rev(cols)
          
          # Rotation mirror (degrees): 
          init_angle <- 250
          
          # --- Draw Donut ---
          par(mar = c(2,2,2,2))
          
          pie(vals_cw,
              labels = paste(labs_cw, ' ', round(vals_cw*100),'%', sep=''),
              clockwise = TRUE,
              init.angle = init_angle,
              radius = 1,
              col = cols_cw,
              border = NA
          )
          
          # Add white circle to create donut hole
          symbols(0, 0, circles = 0.5, inches = FALSE, add = TRUE, bg = "white", fg = "white")
          
          # Add center text (annotation)
          text(0, 0.05, paste("n =", sample_size),
               cex = 1.5, font = 2)
          
        })
        
        # GAME
        GAME_RiskClass <- reactive({
          GAMERiskClass <- as.character(input$ScoreGAME)
          switch(GAMERiskClass,
                 "Low risk: 0-1" = 'ScoreGAME_0-1.txt',
                 "Moderate risk: 2-3" = 'ScoreGAME_2-3.txt',
                 "High risk: 4-7" = 'ScoreGAME_4-7.txt',
                 NA)  # fallback if input is NULL
        })
        
        observe({
          print(paste("Mapped file for GAME score risk class:", GAME_RiskClass()))
        })
        
        output$GAME_relps_title <- renderText({
          paste("<h4>", "GAME Score")
        })
        
        output$GAME_relps_text <- renderText({
          paste(
            "<h6>","Fraction of relapses in KaroLiver by the selected risk class", "<br><h6>",
            "0-1: Low risk","<br>", "2-3: Moderate risk", "<br>", "4-7: High risk")
        })
        
        
        output$GAME_relpsPlot <- renderPlot({
          
          GAMERiskClass_file <- GAME_RiskClass()
          if (is.na(GAMERiskClass_file)) return(NULL)
          
          ScoreGAME <- read.table(paste0("./data/",GAMERiskClass_file), sep=';', header = T)
          
          sample_size <- ifelse(GAMERiskClass_file=='ScoreGAME_0-1.txt', 155,
                                ifelse(GAMERiskClass_file=='ScoreGAME_2-3.txt', 398, 156))
          
          # Data
          vals <- ScoreGAME$fraction
          labs <- ScoreGAME$category
          cols <- c        
          
          
          vals_cw <- rev(vals)
          labs_cw <- rev(labs)
          cols_cw <- rev(cols)
          
          # Rotation mirror (degrees): 
          init_angle <- 250
          
          # --- Draw Donut ---
          par(mar = c(2,2,2,2))
          
          pie(vals_cw,
              labels = paste(labs_cw, ' ', round(vals_cw*100),'%', sep=''),
              clockwise = TRUE,
              init.angle = init_angle,
              radius = 1,
              col = cols_cw,
              border = NA
          )
          
          # Add white circle to create donut hole
          symbols(0, 0, circles = 0.5, inches = FALSE, add = TRUE, bg = "white", fg = "white")
          
          # Add center text (annotation)
          text(0, 0.05, paste("n =", sample_size),
               cex = 1.5, font = 2)
          
        })
        
        
        
        # Fong risk class input
        FongRiskClass <- reactive({
          FRiskClass <- as.character(input$ScoreF)
          switch(FRiskClass,
                 "Low risk: 0-2" = 'ScoreF_0-2.txt',
                 "Moderate risk: 3-4" = 'ScoreF_3-4.txt',
                 "High risk: 5" = 'ScoreF_5.txt',
                 NA)  # fallback if input is NULL
        })
        
        observe({
          print(paste("Mapped file for Fong score risk class:", FongRiskClass()))
        })
        
        output$F_relps_title <- renderText({
          paste("<h4>", "Fong Score")
        })
        
        output$F_relps_text <- renderText({
          paste(
            "<h6>","Fraction of relapses in KaroLiver by the selected risk class", "<br><h6>",
            "0-2: Low risk","<br>", "3-4: Moderate risk", "<br>", "5: High risk")
        })
        
        
        output$F_relpsPlot <- renderPlot({
          
          FRiskClass_file <- FongRiskClass()
          if (is.na(FRiskClass_file)) return(NULL)
          
          ScoreF <- read.table(paste0("./data/",FRiskClass_file), sep=';', header = T)
          sample_size <- ifelse(FRiskClass_file=='ScoreF_0-2.txt', 406,
                                ifelse(FRiskClass_file=='ScoreF_3-4.txt', 299, 5))
          
          # Data
          vals <- ScoreF$fraction
          labs <- ScoreF$category
          cols <- c     
          
          vals_cw <- rev(vals)
          labs_cw <- rev(labs)
          cols_cw <- rev(cols)
          
          # Rotation mirror (degrees): 
          init_angle <- 250
          
          # --- Draw Donut ---
          par(mar = c(2,2,2,2))
          
          pie(vals_cw,
              labels = paste(labs_cw, ' ', round(vals_cw*100),'%', sep=''),
              clockwise = TRUE,
              init.angle = init_angle,
              radius = 1,
              col = cols_cw,
              border = NA
          )
          
          # Add white circle to create donut hole
          symbols(0, 0, circles = 0.5, inches = FALSE, add = TRUE, bg = "white", fg = "white")
          
          # Add center text (annotation)
          text(0, 0.05, paste("n =", sample_size),
               cex = 1.5, font = 2)
          
          
        })
        
        # Nordlinger
        NordRiskClass <- reactive({
          NRiskClass <- as.character(input$ScoreN)
          switch(NRiskClass,
                 "Low risk: 0-2" = 'ScoreNo_0-2.txt',
                 "Moderate risk: 3-4" = 'ScoreNo_3-4.txt',
                 "High risk: 5-7" = 'ScoreNo_5-7.txt',
                 NA)  # fallback if input is NULL
        })
        
        observe({
          print(paste("Mapped file for Nordlinger score risk class:", NordRiskClass()))
        })
        
        output$N_relps_title <- renderText({
          paste("<h4>", "Nordlinger Score")
        })
        
        output$N_relps_text <- renderText({
          paste(
            "<h6>","Fraction of relapses in KaroLiver by the selected risk class", "<br><h6>",
            "0-2: Low risk","<br>", "3-4: Moderate risk", "<br>", "5-7: High risk")
        })
        
        
        output$N_relpsPlot <- renderPlot({
          
          NRiskClass_file <- NordRiskClass()
          if (is.na(NRiskClass_file)) return(NULL)
          
          ScoreN <- read.table(paste0("./data/",NRiskClass_file), sep=';', header = T)
          sample_size <- ifelse(NRiskClass_file=='ScoreNo_0-2.txt', 59,
                                ifelse(NRiskClass_file=='ScoreNo_3-4.txt', 410, 240))
          
          # Data
          vals <- ScoreN$fraction
          labs <- ScoreN$category
          cols <- c2 
          
          vals_cw <- rev(vals)
          labs_cw <- rev(labs)
          cols_cw <- rev(cols)
          
          init_angle <- 250
          
          # --- Draw Donut ---
          par(mar = c(2,2,2,2))
          
          pie(vals_cw,
              labels = paste(labs_cw, ' ', round(vals_cw*100),'%', sep=''),
              clockwise = TRUE,
              init.angle = init_angle,
              radius = 1,
              col = cols_cw,
              border = NA
          )
          
          # Add white circle to create donut hole
          symbols(0, 0, circles = 0.5, inches = FALSE, add = TRUE, bg = "white", fg = "white")
          
          # Add center text (annotation)
          text(0, 0.05, paste("n =", sample_size),
               cex = 1.5, font = 2)
          
          
        })
        
      
        
        # Nagashima 2006
        Na06RiskClass <- reactive({
          Na06RiskClass <- as.character(input$ScoreNa06)
          switch(Na06RiskClass,
                 "Low risk: ≤3" = 'ScoreNa2006_Grade A.txt',
                 "Moderate risk: 3-5" = 'ScoreNa2006_Grade B.txt',
                 "High risk: >5" = 'ScoreNa2006_Grade C.txt',
                 NA)  # fallback if input is NULL
        })
        
        observe({
          print(paste("Mapped file for Na06 score risk class:", Na06RiskClass()))
        })
        
        output$Na06_relps_title <- renderText({
          paste("<h4>", "Nagashima Score")
        })
        
        output$Na06_relps_text <- renderText({
          paste(
            "<h6>","Fraction of relapses in KaroLiver by the selected risk class", "<br><h6>",
            "≤3: Low risk","<br>", ">3 & ≤5: Moderate risk", "<br>", ">5: High risk")
        })
        
        
        output$Na06_relpsPlot <- renderPlot({
          
          Na06RiskClass_file <- Na06RiskClass()
          if (is.na(Na06RiskClass_file)) return(NULL)
          
          ScoreNa06 <- read.table(paste0("./data/",Na06RiskClass_file), sep=';', header = T)
          sample_size <- ifelse(Na06RiskClass_file=='ScoreNa2006_Grade A.txt', 587,
                                ifelse(Na06RiskClass_file=='ScoreNa2006_Grade B.txt', 117, 5))
          
          # Data
          vals <- ScoreNa06$fraction
          labs <- ScoreNa06$category
          cols <- c 
          

          
          # Set clockwise orientation:

          vals_cw <- rev(vals)
          labs_cw <- rev(labs)
          cols_cw <- rev(cols)
          
          # Rotation mirror (degrees): 
          init_angle <- 250
          
          # --- Draw Donut ---
          par(mar = c(2,2,2,2))
          
          pie(vals_cw,
              labels = paste(labs_cw, ' ', round(vals_cw*100),'%', sep=''),
              clockwise = TRUE,
              init.angle = init_angle,
              radius = 1,
              col = cols_cw,
              border = NA
          )
          
          # Add white circle to create donut hole
          symbols(0, 0, circles = 0.5, inches = FALSE, add = TRUE, bg = "white", fg = "white")
          
          # Add center text (annotation)
          text(0, 0.05, paste("n =", sample_size),
               cex = 1.5, font = 2)
          
        })
        
        # Konopke
        KRiskClass <- reactive({
          KRiskClass <- as.character(input$ScoreK)
          switch(KRiskClass,
                 "Low risk: 1" = 'ScoreK_Low.txt',
                 "Moderate risk: 2" = 'ScoreK_Intermediate.txt',
                 "High risk: 3" = 'ScoreK_High.txt',
                 NA)  # fallback if input is NULL
        })
        
        observe({
          print(paste("Mapped file for Konopke score risk class:", KRiskClass()))
        })
        
        output$K_relps_title <- renderText({
          paste("<h4>", "Konopke Score")
        })
        
        output$K_relps_text <- renderText({
          paste(
            "<h6>","Fraction of relapses in KaroLiver by the selected risk class", "<br><h6>",
            "1: Low risk","<br>", "2: Moderate risk", "<br>", "3: High risk")
        })
        
        
        output$K_relpsPlot <- renderPlot({
          
          KRiskClass_file <- KRiskClass()
          if (is.na(KRiskClass_file)) return(NULL)
          
          ScoreK <- read.table(paste0("./data/",KRiskClass_file), sep=';', header = T)
          sample_size <- ifelse(KRiskClass_file=='ScoreK_Low.txt', 234,
                                ifelse(KRiskClass_file=='ScoreK_Intermediate.txt', 307, 168))
          
          # Data
          vals <- ScoreK$fraction
          labs <- ScoreK$category
          cols <- c
          
          vals_cw <- rev(vals)
          labs_cw <- rev(labs)
          cols_cw <- rev(cols)
          
          # Rotation mirror (degrees): 
          init_angle <- 250
          
          # --- Draw Donut ---
          par(mar = c(2, 2, 2, 2))
          
          pie(vals_cw,
              labels = paste(labs_cw, ' ', round(vals_cw*100),'%', sep=''),
              clockwise = TRUE,
              init.angle = init_angle,
              radius = 1,
              col = cols_cw,
              border = NA
          )
          
          # Add white circle to create donut hole
          symbols(0, 0, circles = 0.5, inches = FALSE, add = TRUE, bg = "white", fg = "white")
          
          # Add center text (annotation)
          text(0, 0.05, paste("n =", sample_size),
               cex = 1.5, font = 2)
          
          
          
          
        })

        
}



# Run the application 
shinyApp(ui = ui, server = server)
