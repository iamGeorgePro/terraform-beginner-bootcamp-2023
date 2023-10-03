variable "user_uuid" {
  description = "UUID for the user"
  
  type        = string
  default = "db8fc491-7712-4149-b2c2-19a84f7c3cc6"
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "Invalid user UUID format. Please use a valid UUID."
   }
}
