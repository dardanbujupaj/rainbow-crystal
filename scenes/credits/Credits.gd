extends Control


const licenses = [
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
	
]


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_credits_text()


func generate_credits_text():
	var text = "[center]"
	
	for license in licenses:
		text += generate_license_line(license)
	
	text += "[/center]"
	
	$PanelContainer/VBoxContainer/RichTextLabel.bbcode_text = text

func generate_license_line(entry: Dictionary):
	var title = build_url(entry.get("title"), entry.get("url"))
	var license = build_url(entry.get("license"), entry.get("license_url"))
	
	return "%s by %s. %s\n" % [title, entry.get("author"), license]


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
