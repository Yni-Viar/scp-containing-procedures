extends Node3D
## Made by Yni, licensed under CC0.
class_name BasePuppetScript

@export var armature_name: String = "HumanRig"
enum States {IDLE, WALKING, RUNNING, SPECIAL1, SPECIAL2, SPECIAL3, SPECIAL4}
@export var state: States = States.IDLE
