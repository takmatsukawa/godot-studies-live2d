extends Node

const Balloon = preload("res://dialogue/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func _on_mao_touched() -> void:	
	$StateChart.send_event("dialogue_started")

func _on_balloon_dialogue_finished() -> void:
	$StateChart.send_event("dialogue_finished")


func _on_chatting_state_entered() -> void:
	$Mao.start_angry()
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.dialogue_finished.connect(_on_balloon_dialogue_finished)
	balloon.start(dialogue_resource, dialogue_start)
