 {sp}←Bar data;L;max;min;xrange;⎕IO

 require'sharpPlot'
 sp L←sharpPlot

 ⎕IO←0
 :If 0=≢data ⋄ data←1 ⋄ :EndIf
 :If 1=≢data
     :Select ⍬⍴data
     :Case 0 ⋄ data←(6 18 27 31 40 43)(17 33 42 54 71 78)
     :Case 1 ⋄ data←(?10⍴10)(8+2*⍨?10⍴2)(8+1○10×?10⍴0)
     :Else ⋄ ⋄ data←(15-?5⍴10)(15-0.5*⍨?5⍴100)(15-?5⍴10)(15-0.5*⍨?5⍴100)
     :EndSelect
 :EndIf
 xrange←⌽⎕TS[0]-⍳∊⌈/⍴¨data ⋄ min max←(⍕⌊/xrange)(⍕⌈/xrange)
 sp.Heading←'Overall Spend by Unit⋄',min,' to ',max
 sp.SetHeadingFont'Arial' 13 L.FontStyle.Bold L.Color.Blue


 sp.BarChartStyle←L.BarChartStyles.(TicksBetween+ValueTags+ForceZero)
 sp.XAxisStyle←L.XAxisStyles.(MiddleLabels+GridLines)

 sp.ValueTagStyle←L.ValueTagStyles.(Vertical+Inside+SectorValues+RecolorOutside)
 sp.SetValueFont'Courier,Arial' 10 L.FontStyle.Bold L.Color.LightYellow
 sp.ValueTagFormat←'$###0M'

 sp.Gap←0
 sp.GroupGap←0.5
 sp.SetColors L.Color.(Red Orange Yellow Green Blue Violet)

 sp.XLabelFormat←'####' ⍝ years
 sp.SetXLabels xrange   ⍝ years
 sp.SetKeyText'Sales' 'Marketing' 'Research' 'Finance' 'Facilities' 'Dining' 'Hair Salon'

 sp.DrawBarChart(data)
 sp.Show
