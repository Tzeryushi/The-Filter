extends Node
## Broadcaster contains signals that can be fired off by anyone, and connected
## to by anyone. This is DANGEROUS! Use this sparingly.


signal clipboard_form_submitted(approved: bool)
signal clipboard_form_changed(complication: String, value: bool)
