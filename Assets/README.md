# Assets

This folder is a place to keep project asset references and your original image files.
Delta may not expose a filesystem path to Roblox GUI code. A PNG stored here will not
automatically appear in an ImageLabel.

Recommended:
- For Roblox UI images, use a Roblox image asset ID such as `rbxassetid://123456789`.
- A raw GitHub or other web URL is only a reference; Roblox ImageLabel does not generally
  render arbitrary external URLs directly.
- If Delta offers a documented image-loading API, verify its expected input and output first.
