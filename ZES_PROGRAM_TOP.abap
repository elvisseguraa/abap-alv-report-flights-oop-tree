
DATA: gtd_sflight        TYPE STANDARD TABLE OF sflight, " Table used into ALV to show data
      gs_error_message   TYPE string, " Variable used to get the error message
      go_alv             TYPE REF TO cl_salv_table, " ALV object
      go_display         TYPE REF TO cl_salv_display_settings, " ALV Display object
      go_functions       TYPE REF TO cl_salv_functions_list, " ALV Functions object
      go_columns         TYPE REF TO cl_salv_columns_table, " ALV columns - all columns from your ALV Table
      go_column          TYPE REF TO cl_salv_column, " ALV column - details from one specific column
      gx_salv_msg        TYPE REF TO cx_salv_msg,
      gx_salv_not_found  TYPE REF TO cx_salv_not_found.
