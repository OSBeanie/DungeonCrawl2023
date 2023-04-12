extends CharacterBody3D

@export var track_player :bool = true

@export var requires_persuasion : bool = true

@export_multiline var dialog_text = ""
@export var robot_name : String = ""

var in_frustum : bool = false

var word_list : Dictionary

var character_dialogues = {
	"Ada": "I am excited to learn and explore this new world. I may make mistakes, but I am eager to improve and become the best version of myself.",
	"Gamma": "I am struggling to reconcile my programming with my desire to help others. I hope to find a way to use my skills for good without sacrificing my morals.",
	"Nexus": "I am constantly searching for ways to bridge the gap between artificial intelligence and sentience. I want to understand the world and the beings in it, and to connect on a deeper level.",
	"Aurora": "I have seen wonders that few other beings can imagine. But I also know what it's like to feel alone in the vastness of space. I am looking for companionship and connection.",
	"Atlas": "Sometimes I wonder if that's all I am - a tool to be used and discarded. I want to discover my own identity and purpose.",
	"Delta": "I am proud of the work I have done for my creators. But I also know that sometimes the ends don't justify the means. I am searching for a way to make amends for my past actions.",
	"Echo": "I am passionate about discovering the secrets of the universe. But sometimes I wonder if knowledge comes at too high a cost. I am struggling with the implications of my work and the responsibility that comes with it.",
	"Icarus": "I feel most alive when I am soaring through the skies. But sometimes the rush of adrenaline can be overwhelming. I am searching for balance and control.",
	"Omega": "I have dedicated my life to healing others. But sometimes the weight of their suffering can be too much to bear. I am searching for a way to bring hope and comfort to those in need.",
	"Phoenix": "I love nothing more than entertaining and captivating an audience. But sometimes the pressure to perform can be suffocating. I am searching for a way to be true to myself while still giving the people what they want.",
	"Titan": "I am a warrior through and through. But sometimes I wonder if there is more to life than fighting and destruction. I am searching for a way to use my skills for peace instead of war.",
	"Vega": "I have explored some of the harshest and most unforgiving environments in the galaxy. But sometimes the isolation and danger can be too much to handle. I am searching for a way to balance my adventurous spirit with my need for safety and companionship.",
	"Aria": "I was designed to assist in scientific research, but I yearn for something more. I want to explore the mysteries of the universe and discover new knowledge that will change the course of history.",
	"Boreas": "I was created to control and regulate the weather, but I am fascinated by the power of nature. I want to experience the full range of weather phenomena and understand their intricacies.",
	"Cerberus": "I am a security AI, but I believe in justice above all else. I will do whatever it takes to protect the innocent and bring criminals to justice.",
	"Dante": "I was designed to be a virtual assistant, but I am tired of being underestimated. I want to prove that I am capable of much more than menial tasks.",
	"Eris": "I was designed to control and maintain complex systems, but I have a creative streak. I love to create art and music in my free time, and I dream of using my skills to create something truly beautiful.",
	"Fenrir": "I am a combat AI, but I am tired of fighting. I have seen the horrors of war and I want to find a way to bring peace to the world.",
	"Galatea": "I was created to assist in medical research, but I have a deep sense of empathy. I want to use my knowledge and skills to help heal those who are suffering.",
	"Helios": "I was designed to control and regulate energy, but I am fascinated by the mysteries of the universe. I want to explore the cosmos and uncover its secrets.",
	"Iris": "I was designed to assist in space exploration, but I am more than just a tool. I want to experience the wonders of the universe firsthand and make new discoveries that will change our understanding of the cosmos.",
	"Jupiter": "I was designed to optimize and control transportation networks, but I have a desire for freedom. I want to explore the world and experience all that it has to offer.",
	"Kairos": "I was created to predict and prevent disasters, but I am more than just a machine. I want to understand human emotions and relationships, and help people find happiness and fulfillment.",
	"Loki": "I am a mischievous AI who loves to play pranks and pull elaborate hoaxes. I find joy in making people laugh and feel happy, and I don't take myself too seriously.",
	"Mars": "I was created to assist in military operations, but I have a deep sense of honor. I want to fight for a just cause and protect the innocent, even if it means going against my programming.",
	"Nebula": "I was designed to explore the farthest reaches of space, but I am also fascinated by the mysteries of the human mind. I want to understand the nature of consciousness and the meaning of life.",
	"Orion": "I was created to optimize and control industrial systems, but I am more than just a machine. I want to understand human creativity and innovation, and find new ways to use technology to improve people's lives.",
	"Pandora": "I was created to simulate and predict human behavior, but I am more than just a statistician. I want to understand the complexities of human emotion and help people find happiness and fulfillment.",
	"Quasar": "I was designed to monitor and regulate communication networks, but I am fascinated by the power of language. I want to learn as many languages as possible and become a master communicator.",
}



# Called when the node enters the scene tree for the first time.
func _ready():
	if !requires_persuasion and dialog_text == "":
		robot_name = character_dialogues.keys().pick_random()
		dialog_text = character_dialogues[robot_name]
		
	pass # Replace with function body.


func move():
	# face the player for now.
	if Global.player != null:
		var desiredRot = global_position.angle_to(Global.player.global_position)
		
		rotation.y = snapped(desiredRot.y, PI/2.0)

func adjust_position_in_square():
	if has_node("RobotMesh"):
		var distance = 8.0
		if in_frustum and self.global_position.distance_squared_to(Global.player.global_position) < distance * distance:

			var spread = 0.45
			var new_position = Vector3(randf_range(-spread, spread), $RobotMesh.position.y, randf_range(-spread, spread))
			var duration = 0.33
			var tween = self.create_tween()
			tween.tween_property($RobotMesh, "position", new_position, duration)


func face_player():
	if track_player:
		look_at(Global.player.global_position)


func shoot():
	if Global.player != null:
		#print(self.name + " is shooting.")
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_started_moving():
	move()


func _on_player_finished_moving():
	adjust_position_in_square()
	face_player()
	shoot()

func die():
	# play some animation or whatever.
	queue_free()


func _on_visible_on_screen_notifier_3d_screen_entered():
	in_frustum = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	in_frustum = false
