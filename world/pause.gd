extends CanvasLayer


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause()


func _on_Button_button_down():
	pause()


func pause():
	get_tree().paused = !get_tree().paused
	$button.visible = !$button.visible
