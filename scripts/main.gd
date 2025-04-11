extends Node2D

 # Define variables
var global_blob_count = 0
var current_blobs = 0
var time : float # In seconds

func _process(delta: float) -> void:
	 # Update blob and blobs ever count
	time += delta
	$CanvasLayer/BlobsEverAndMore.text = "Blobs Ever: " + str(global_blob_count)
	$CanvasLayer/Blobs.text = "Blobs: " + str(current_blobs)
	$CanvasLayer/Blobs.text = "Blobs: " + str(current_blobs)
	if time < 60:
		$CanvasLayer/BlobsEverAndMore.text += "\n\nTime: " + String("%0.3f" % time) + " Seconds"
	elif time < 3600:
		$CanvasLayer/BlobsEverAndMore.text += "\n\nTime: " + String("%0.3f" % (time / 60)) + " Minutes"
	else:
		$CanvasLayer/BlobsEverAndMore.text += "\n\nTime: " + String("%0.3f" % (time / 3600)) + " Hours"
