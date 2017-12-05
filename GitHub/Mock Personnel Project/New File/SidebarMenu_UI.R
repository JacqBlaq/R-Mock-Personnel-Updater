output$Semi_collapsible_sidebar=renderMenu({
      sidebarMenu(
            hr(),
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Search Personnel", tabName = "personnel", icon = icon("id-badge")),
            menuItem("Download Files", tabName = "files", icon = icon("group")),
            menuSubItem("Monthly Expander", tabName = "expander", icon = icon("expand")),
            hr()
      )#sidebarMenu
})