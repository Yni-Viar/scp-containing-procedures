extends BasePuppetScript
## Base puppet script for vision-based entities
## Created by Yni, licensed under MIT License
class_name VisionScpPuppetScript

var watching_puppets: Array[Node3D] = []
var freeze: bool = false
