Attribute VB_Name = "Project_1_VBA"

' Format q1, q2 and q3 in original qualifying data
Sub format_qualifying_q1_q2_q3()
' \N values are removed
' All time set is formatted to h:mm:ss.000

lastrow = Cells(Rows.Count, 1).End(xlup).Row

For i = 1 To lastrow
    For j = 7 To 9
        If Cells(i, j) = "\N" Then
            Cells(i, j).ClearContents
        Else
            Cells(i, j).NumberFormat = "h:mm:ss.000"
        End If
    Next j
Next i

End Sub

' DOB format drivers csv
Sub dob_format()

lastrow = Cells(Rows.Count, 1).End(xlup).Row
For i = 1 To lastrow
    Cells(i, 7).NumberFormat = "yyyy/mm/dd"
Next i
End Sub

' Remove “\N” from column ‘number’
Sub driver_number_remove_N()

lastrow = Cells(Rows.Count, 1).End(xlup).Row

For i = 1 To lastrow
    If Cells(i, 3) = "\N" Then
        Cells(i, 3).ClearContents
    End If
Next i
End Sub

' Remove “\N” from column ‘code’
Sub driver_code_remove_N()

lastrow = Cells(Rows.Count, 1).End(xlup).Row

For i = 1 To lastrow
    If Cells(i, 4) = "\N" Then
        Cells(i, 4).ClearContents
    End If
Next i
End Sub

' Remove “\N” from time in races csv
Sub races_time_remove_N()

lastrow = Cells(Rows.Count, 1).End(xlup).Row

For i = 1 To lastrow
    If Cells(i, 7) = "\N" Then
        Cells(i, 7).ClearContents
    End If
Next i
End Sub

' Format date in races csv
Sub races_date_format()

lastrow = Cells(Rows.Count, 1).End(xlup).Row
For i = 1 To lastrow
    Cells(i, 6).NumberFormat = "yyyy/mm/dd"
Next i
End Sub
New CSV code

' Format q1, q2 And q3
Sub format_new_csv_qualifying_q1_q2_q3()
' DNF values are removed
' All time set is formatted to h:mm:ss.000

lastrow = Cells(Rows.Count, 1).End(xlup).Row

For i = 1 To lastrow
    For j = 6 To 8
        If Cells(i, j) = "DNF" Then
            Cells(i, j).ClearContents
        Else
            Cells(i, j).NumberFormat = "h:mm:ss.000"
        End If
    Next j
Next i

End Sub

' remove “NC” from position column
Sub new_csv_remove_NC()

lastrow = Cells(Rows.Count, 1).End(xlup).Row

For i = 1 To lastrow
    If Cells(i, 3) = "NC" Then
        Cells(i, 3).ClearContents
    End If
Next i
End Sub
