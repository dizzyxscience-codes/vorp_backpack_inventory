Config = {}

Config.OpenCommand = "backpack"
Config.OpenKey = "K"

Config.Title = "Backpack"
Config.WeightUnit = "kg"
Config.MaxWeight = 75.0

-- If true, the script will generate demo items when VORP inventory data is unavailable.
Config.EnableFallbackItems = true

-- Server events used for item actions.
-- Change these to match your framework if needed.
Config.UseItemEvent = "vorp:useItem"
Config.DropItemEvent = "vorp_backpack_inventory:customDrop"

-- Amount removed by default when pressing Drop.
Config.DefaultDropAmount = 1
