@tool
extends EditorExportPlugin


func _get_name() -> String:
	return "WebRuntimeData"


func _export_begin(features: PackedStringArray, _is_debug: bool, _path: String, _flags: int) -> void:
	if not features.has("web"):
		return
	for folder in ["Assets", "bin", "Sounds"]:
		var source := ProjectSettings.globalize_path("res://").path_join(folder)
		if not DirAccess.dir_exists_absolute(source):
			push_error("Cannot package missing web data directory: " + source)
			continue
		for file in DirAccess.get_files_at(source):
			var extension := file.get_extension().to_lower()
			if folder == "Assets" and extension not in ["jpg", "png", "md2", "3ds"]:
				continue
			if folder == "Sounds" and extension != "wav":
				continue
			if folder == "bin" and extension not in ["dat", "map", "mod", "cmp", "snd", "txt"]:
				continue
			var f := FileAccess.open(source.path_join(file), FileAccess.READ)
			if f == null:
				push_error("Cannot package web data file: " + source.path_join(file))
				continue
			add_file("res://".path_join(folder).path_join(file), f.get_buffer(f.get_length()), false)
