alias Spreadsheets.Data.Matrix

{:ok, pid} = Matrix.start_link(%Matrix{name: "1fV9Cl8KRtrGxCr7_V_Zqz4XUvCl6cqgH_tDwlrQ1fQk"})

matrix = Spreadsheets.Data.Matrix.get_all "1fV9Cl8KRtrGxCr7_V_Zqz4XUvCl6cqgH_tDwlrQ1fQk"
