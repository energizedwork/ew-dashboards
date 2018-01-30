# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Core.Repo
alias Core.Schemas.DataSource
# alias Core.Schemas.WidgetDataSource
#
# Repo.delete_all(WidgetDataSource)
# Repo.delete_all(DataSource)

data_sources =  [
  %DataSource{
    name: "Matt's test sheet",
    meta: %{sheet_name: "Sheet1",
            range: "A1:l7",
            sheet_id: "1P0okW7oVus2KR423Ob1DgbVNCbR_QNg3OjNPj04zcsI"
          }
  },
  %DataSource{
    name: "Matt's test sheet (RobC tab)",
    meta: %{sheet_name: "RobC",
            range: "A1:Z200",
            sheet_id: "1P0okW7oVus2KR423Ob1DgbVNCbR_QNg3OjNPj04zcsI"
          }
  },
  %DataSource{
    name: "Matt's test sheet #2",
    meta: %{sheet_name: "MSP",
            range: "A1:C7",
            sheet_id: "1P0okW7oVus2KR423Ob1DgbVNCbR_QNg3OjNPj04zcsI"
          }
  },
  %DataSource{
    name: "Odette's 365 MPAN sheet",
    meta: %{sheet_name: "grid",
            range: "A1:NB49",
            sheet_id: "1p5cypRkxrxpmtONEOBEWP2BbMowfzQNaZ_YfNb_hkyE"
          }
  },
  %DataSource{
    name: "Odette's 4 day MPAN sheet",
    meta: %{sheet_name: "grid",
            range: "A1:D49",
            sheet_id: "1KcN1-QPWueW6WySdW5bTupV41UkvvktnVryw_cj9TeQ"
          }
  },
  %DataSource{
    name: "Matt's KPI deck clone",
    meta: %{sheet_name: "GM&PM MoM",
            range: "B27:Q34",
            sheet_id: "1wVQwHXWx3tMB0eOhRVfqIFwdv0_lmcrluHi4KavkxZQ"
          }
  },
  %DataSource{
    name: "EW KPI deck December 2017 (DRAFT) - Cash Flow",
    meta: %{sheet_name: "Cash Flow",
            range: "A1:Z500",
            sheet_id: "1bfVq7-UpBvX7aBFXqoeW_-045iGK676_orI9swp8OKw"
          }
   },
  %DataSource{
    name: "EW KPI deck December 2017 (DRAFT) - Summary",
    meta: %{sheet_name: "Summary",
            range: "A1:Z500",
            sheet_id: "1bfVq7-UpBvX7aBFXqoeW_-045iGK676_orI9swp8OKw"
          }
   },
  %DataSource{
    name: "EW KPI deck December 2017 (DRAFT) - GM&PM YoY",
    meta: %{sheet_name: "GM&PM YoY",
            range: "A1:Z500",
            sheet_id: "1bfVq7-UpBvX7aBFXqoeW_-045iGK676_orI9swp8OKw"
          }
   }
]

for ds <- data_sources do
  IO.puts "Checking existence of data source: #{ds.name}"
  existing_data_source = Repo.get_by(DataSource, name: ds.name)

  unless existing_data_source do
    IO.puts "Inserting new data source: #{ds.name}"
    Repo.insert!(ds)
  end
end
