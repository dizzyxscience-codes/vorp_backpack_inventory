# vorp_backpack_inventory

Clean RedM backpack-style inventory UI for VORP.

## Install

1. Put `vorp_backpack_inventory` in your RedM resources folder.
2. Add this line to your `server.cfg`:

   ```
   ensure vorp_backpack_inventory
   ```

3. Restart the server.

## Default Controls

- Open command: `/backpack`
- Default key: `K`

You can change both in `shared/config.lua`.

## VORP Integration

This script attempts to read inventory from:

- `exports.vorp_inventory:getUserInventory(source)`

If your VORP version uses different exports/events, edit `server/server.lua` and `shared/config.lua`.

## Item Actions

- Use: triggers event set in `Config.UseItemEvent` (default: `vorp:useItem`)
- Drop: triggers event set in `Config.DropItemEvent` (default: `vorp_backpack_inventory:customDrop`)

Wire these to your preferred inventory handlers if your framework names differ.
