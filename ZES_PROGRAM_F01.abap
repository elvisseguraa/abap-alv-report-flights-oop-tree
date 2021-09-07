FORM select_data .

  "Select data to use and show into the ALV
  SELECT * UP TO 20 ROWS INTO TABLE gtd_sflight
    FROM sflight.

ENDFORM.


FORM create_alv_object .

  " Get ALV object instance ready to use.
  " You don't need to inform any field detail to the ALV such as Name, Text, Position, Data Type, F1 Help, etc.
  " The ALV will assume all information from the Data Element used in the table and fields.
  TRY .
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gtd_sflight
      ).

    CATCH cx_salv_msg INTO gx_salv_msg.
      
      gs_error_message = gx_salv_msg->get_text( ).
      WRITE gs_error_message.
      
  ENDTRY.

ENDFORM.



FORM set_alv_display .

  DATA: lv_title TYPE lvc_title. " Variable which will receive the new ALV title

  "New ALV title
  lv_title = 'MY FIRST ALV FACTORY'.
  " Get the reference for ALV Display Settings object
  go_display = go_alv->get_display_settings( ).
  " Set striped pattern aka Zebra
  go_display->set_striped_pattern( if_salv_c_bool_sap=>true ).
  " Set new ALV title
  go_display->set_list_header( lv_title ).

ENDFORM.                    " SET_ALV_DISPLAY


FORM set_alv_functions .

  "Get the reference for ALV Functions object
  go_functions = go_alv->get_functions( ).
  "Set all standard functions in toolbar to be used
  go_functions->set_all( if_salv_c_bool_sap=>true ).

ENDFORM.                    "set_alv_functions



FORM format_columns.

  " Get the reference for ALV Columns, all columns from your ALV Table
  go_columns = go_alv->get_columns( ).
  " ALV will open with all columns adjusted to show the data
  " You can do the same per column, instead for all table, using GO_COLUMN->SET_OPTIMIZED( if_salv_c_bool_sap=>true )
  go_columns->set_optimize( if_salv_c_bool_sap=>true ).

  PERFORM set_column_alignment.
  PERFORM set_column_color.
  PERFORM set_column_checkbox.
  PERFORM set_column_key.
  PERFORM set_column_position.
  PERFORM set_column_text.
  PERFORM set_column_tooltip.
  PERFORM set_column_visibility.
  PERFORM set_column_zero.

ENDFORM.



FORM set_column_alignment .

  TRY.
      " Get reference for ALV column object
      go_column = go_columns->get_column( columnname = 'PLANETYPE' ).
      " Set new alignment (centralized)
      go_column->set_alignment( 3 ).

    CATCH cx_salv_not_found INTO gx_salv_not_found.
      
      gs_error_message = gx_salv_not_found->get_text( ).
      WRITE gs_error_message.
      
  ENDTRY.

ENDFORM.                    "set_column_alignment



FORM set_column_color .
  
  "Change column color

  DATA: ls_color  TYPE lvc_s_colo, " Structure with color informations
        lo_column TYPE REF TO cl_salv_column_table. " To set the column color we must use another class

  ls_color-col = 3. " Color
  ls_color-int = 0. " Intensity
  ls_color-inv = 0. " Inverted

  TRY .
      " Get reference for ALV column object.
      " Observe that we use another class to manipulate the column color
      lo_column ?= go_columns->get_column( 'PLANETYPE' ).

      " Set color for a single column
      lo_column->set_color( ls_color ).

    CATCH cx_salv_not_found INTO gx_salv_not_found.
      gs_error_message = gx_salv_not_found->get_text( ).
      WRITE gs_error_message.
  ENDTRY.

ENDFORM.




FORM set_column_checkbox .
*gr_column->set_cell_type( if_salv_c_cell_type=>checkbox ).
ENDFORM.



FORM set_column_key .
  
  "Change the table key

  DATA: lo_column TYPE REF TO cl_salv_column_table. " To set the column as key we must use another class

  TRY .
      " Get reference for ALV column object.
      lo_column ?= go_columns->get_column( 'PRICE' ).
      " Set new key to the table. PRICE is not key in SFLIGHT, but will appear as one now (it's just for test, ok?)
      " Observe that we use another class to manipulate the table key
      lo_column->set_key( if_salv_c_bool_sap=>true ).

    CATCH cx_salv_not_found INTO gx_salv_not_found.
      gs_error_message = gx_salv_not_found->get_text( ).
      WRITE gs_error_message.
  ENDTRY.

ENDFORM.


FORM set_column_position .
  
  "Change the original position where a column will appear

  " Set new position for a column
  " Plane type will appear at the end of the table, the last column position
  go_columns->set_column_position(
    columnname = 'PLANETYPE'
    position   = 14
  ).

ENDFORM.



FORM set_column_text .

  TRY.
      " Get reference for ALV column object
      go_column = go_columns->get_column( columnname = 'PLANETYPE' ).
      " Set new text
      go_column->set_short_text( 'NewTxtPlTy' ).
      go_column->set_medium_text( 'New Txt PlaneType').
      go_column->set_long_text( 'New Text for Plane Type' ).

    CATCH cx_salv_not_found INTO gx_salv_not_found.
      
      gs_error_message = gx_salv_not_found->get_text( ).
      WRITE gs_error_message.
      
  ENDTRY.

ENDFORM.


FORM set_column_tooltip .

  TRY.
      " Get reference for ALV column object
      go_column = go_columns->get_column( columnname = 'PLANETYPE' ).
      " Set new tooltip
      go_column->set_tooltip( 'New tooltip for this column header' ).

    CATCH cx_salv_not_found INTO gx_salv_not_found.
      
      gs_error_message = gx_salv_not_found->get_text( ).
      WRITE gs_error_message.
      
  ENDTRY.

ENDFORM.



FORM set_column_visibility .

  TRY.
      " Get reference for ALV column object
      go_column = go_columns->get_column( columnname = 'MANDT' ).
      " Set column as technical means that this column won't be visible in your ALV (never)
      go_column->set_technical( if_salv_c_bool_sap=>true ).
      " Get reference for ALV column object
      go_column = go_columns->get_column( columnname = 'FLDATE' ).
      " Set column as invisible, but you can edit the layout on the fly to show it whenever you want
      go_column->set_visible( if_salv_c_bool_sap=>false ).

    CATCH cx_salv_not_found INTO gx_salv_not_found.
      
      gs_error_message = gx_salv_not_found->get_text( ).
      WRITE gs_error_message.
      
  ENDTRY.

ENDFORM.


FORM set_column_zero .
  
  "Change the way how field value = ZERO is shown
  TRY.
      " Get reference for ALV column object
      go_column = go_columns->get_column( columnname = 'PAYMENTSUM' ).
      " If a field from this column has value = ZERO (0), it will shown as SPACE
      go_column->set_zero( if_salv_c_bool_sap=>false ).

    CATCH cx_salv_not_found INTO gx_salv_not_found.
      
      gs_error_message = gx_salv_not_found->get_text( ).
      WRITE gs_error_message.
      
  ENDTRY.

ENDFORM.



FORM show_alv .

  go_alv->display( ). " Show ALV Grid

ENDFORM.