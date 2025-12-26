 sp←sp DrawTable data;font;pan_d;pot_d;tabledata
 L←sp.L
 sp.SetMargins 4⍴44
 sp.DrawFrame
 sp.SetYLabels'North' 'South' 'East' 'West' 'Total'
 sp.SetXLabels'Pots' 'Pans'
 pot_d←18 27 31 1
 pan_d←12 9 7 13
 tabledata←(pot_d,+/pot_d)(pan_d,+/pan_d)
 sp.YCaption←'Summary'
 sp.TableStyle←L.TableStyles.(Boxed+GridLines+FitWidth+FitHeight)
 font←6
 sp.SetValueFont'Arial'(font)(L.Color.Firebrick)
 sp.SetLabelFont'Arial'(font)
 sp.SetCaptionFont'Arial'(font-1)
 sp.DrawTable tabledata
