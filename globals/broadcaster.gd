extends Node
## Broadcaster contains signals that can be fired off by anyone, and connected
## to by anyone. This is DANGEROUS! Use this sparingly.


signal clipboard_form_submitted(results: Dictionary)
signal clipboard_form_changed(complication: String, value: bool)

signal client_manager_new_client_made(new_client: Client)
signal client_manager_new_resource_used(new_resource: ClientResource)

signal check_clipboard(client_resource: ClientResource)
