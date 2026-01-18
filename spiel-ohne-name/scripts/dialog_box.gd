extends Node2D

#do not use newline character "\n" or it will not work properly
#var Prompt: String = "This is a test message. maybe it will work, maybe it wont... who knows... 3 lines are good i guess yep, lets try it random words that doesnt make any send´se but add to the length of the string. all nonsense is welcome was long as it helps extending this block of text for testing reasons";
var Prompt: String = "";
var totalTime: int = 0;
var Allready_displayed_chars: int = 0;
var Time_per_char_ms: int = 10;
var eligible_for_next: bool = false;
var Text_completely_displayed = false;

func _process(delta: float) -> void:
	totalTime += delta * 1000;
	if ($labelOne.get_line_count() <= 3):
		$labelOne.text = Prompt.substr(Allready_displayed_chars, totalTime / Time_per_char_ms);
	if ($labelOne.get_line_count() > 3): eligible_for_next = true;
	if (Prompt.length() <= Allready_displayed_chars + $labelOne.text.length()): Text_completely_displayed = true;
	if (eligible_for_next or Text_completely_displayed):
		$AnimatedSprite2D.visible = true;

func _input(event: InputEvent) -> void:
	if (Input.is_key_pressed(KEY_ENTER) and eligible_for_next):
		totalTime = 0;
		Allready_displayed_chars += $labelOne.text.rfind(" ") + 1;
		$labelOne.text = "";
		eligible_for_next = false;
		$AnimatedSprite2D.visible = false;
		
func reset() -> void:
	Prompt = "";
	totalTime = 0;
	Allready_displayed_chars = 0;
	eligible_for_next = false;
	Text_completely_displayed = false;
	$labelOne.text = "";
		
#wie setzt man einen neuen text in die dialogbox ein? so:
#func _input(event: InputEvent) -> void:
#	if (Input.is_key_pressed(KEY_ENTER) and $DialogBox.Text_completely_displayed):
#		$DialogBox.reset();
#		$DialogBox.Prompt = "This is the second prompt";
