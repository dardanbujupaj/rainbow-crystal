extends Control


const licenses = [
	# Music Player
	{
		"title": "Crystals",
		"url": "https://zitronsound.bandcamp.com/track/crystals",
		"author": "ZitronSound",
		"license": "CC BY-ND 3.0",
		"license_url": "https://creativecommons.org/licenses/by-nd/3.0/"
	},
	{
		"title": "Awakening",
		"url": "https://zitronsound.bandcamp.com/track/awakening",
		"author": "ZitronSound",
		"license": "CC BY-ND 3.0",
		"license_url": "https://creativecommons.org/licenses/by-nd/3.0/"
	},
	{
		"title": "Rise and Fall",
		"url": "https://zitronsound.bandcamp.com/track/rise_and_fall",
		"author": "ZitronSound",
		"license": "CC BY-ND 3.0",
		"license_url": "https://creativecommons.org/licenses/by-nd/3.0/"
	},
	{
		"title": "Apocalypse",
		"url": "https://zitronsound.bandcamp.com/track/apocalypse",
		"author": "ZitronSound",
		"license": "CC BY-ND 3.0",
		"license_url": "https://creativecommons.org/licenses/by-nd/3.0/"
	},
	{
		"title": "Showdown",
		"url": "https://zitronsound.bandcamp.com/track/showdown",
		"author": "ZitronSound",
		"license": "CC BY-ND 3.0",
		"license_url": "https://creativecommons.org/licenses/by-nd/3.0/"
	},
	
	
	
	# Font
	{
		"title": "Press Start 2P",
		"url": "https://fonts.google.com/specimen/Press+Start+2P?preview.text_type=custom#about",
		"author": "CodeMan38",
		"license": "OFL",
		"license_url": "https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL"
	},
	
]


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_credits_text()


func generate_credits_text():
	var text = "[center]"
	
	text += "Game by Dardan Bujupaj\n"
	text += "Art with help from Ardian and Stephanie\n\n"
	
	
	text += "Made with [url=https://godotengine.org]Godot[/url]\n"
	text += "Sourcecode available at [url=https://github.com/dardanbujupaj/rainbow-crystal]Github[/url]\n\n"
	
	
	text += "Licenses: \n"
	
	
	for license in licenses:
		text += generate_license_line(license)
	
	text += "[/center]"
	
	$PanelContainer/VBoxContainer/RichTextLabel.bbcode_text = text

func generate_license_line(entry: Dictionary):
	var title = build_url(entry.get("title"), entry.get("url"))
	var license = build_url(entry.get("license"), entry.get("license_url"))
	
	return "%s by %s. %s\n\n" % [title, entry.get("author"), license]


func build_url(description, url):
	return (
		"[url=%s]%s[/url]" % [url, description]
		if not url == null
		else description
	)




func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)


func _on_Close_pressed() -> void:
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
