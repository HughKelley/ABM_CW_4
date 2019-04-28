; Template for building ABM with Netlogo
; From an ODD way to describe a model: (Overview, Design concepts, Details)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; throw in a histogram of the distribution of study spaces across patches?

; all global variables
; for variables set from GUI, include but comment out
globals
[
;  optimal-ticks        ; if search costs were 0 how long would it take for the work to be accomplished.
  work-done            ; work completed so far
  total-space          ; sum of patch [space ]
  total-occupants      ; sum of patch [occupants]
  total-work           ; sum of turtle [work]
  ; occupancy            ; of study spaces filled
  ; test-variable        ; for debugging
  ; test                 ; for debugging
  ; percentage-occupied  ; total occupants / total space
  ; search-function      ; use to set the function used for searching dynamically
  ; spaces             ; number of total study spaces
  ; places             ; total number of patches with study space
  ; work-mean          ; amount of work the average turtle has to do
  ; step-size          ; number of steps a turtle can take in one tick
]

; patch state variables
patches-own
[
  space     ; max amount of turtles that can study there
  occupants ; current number of turtles studying there
  ratio     ; percentage of open space
]

; turtle state variables
turtles-own
[
  work      ; amount of ticks they still need to occupy a study patch
  working   ; studying: true or searching: false
  target    ; the next study patch they will check taken from the itinerary
  itinerary ; this is a list of places to check for space
  origin    ; this is where the turtle appears during setup and needs to return to
]


;just go crazy with the semicolons to highlight code that calls the search function

; set search function
; this isn't workable because of inability to pass arguments to a procedure called by "runresult"
;to set-search
;
;  ifelse search-type = "proximity" [ set search-function "proximity"]
;  [
;    ifelse search-type = "most" [set search-function "most"]
;    [
;      ifelse search-type = "percent-taken" [set search-function "perc-taken"]
;      [
;        ifelse search-type = "absolute-availability" [set search-function "availability"]
;        [
;          ifelse search-type = "weighted" [set search-function "weighted"]
;          [
;            show "invalid search procedure specified"
;          ] ; end error-catch else
;        ] ; end fourth if
;      ] ; end third if
;    ] ; end second if
;  ] ;end first if
;end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; initial setup conditions and procedure
to setup
	

  ; reset real-time value
  reset-timer


  	;clear all
	ca


  ; define search function
  ; set-search


  ; setup patches
  let j 2 * spaces
  ask n-of places patches [ set space random j ]
  ask patches [set pcolor scale-color green space 0 j]

  ; show "patches set"

	; create turtles
  let k students / 5
  crt k [
    setxy min-pxcor min-pycor
  ]

  crt k [
    setxy min-pxcor max-pycor
  ]

  crt k [
    setxy max-pxcor min-pycor
  ]

  crt k [
    setxy max-pxcor max-pycor
  ]

  crt k [
    setxy random-pxcor random-pycor
  ]

  ; show "turtles created"

  ask turtles
  [
    initialize
  ]


  set work-done 0
  set total-work (sum [work] of turtles)
  set total-space (sum [space] of patches)

;  set optimal-ticks optimal
  ; show "optimal time required is: "
  ; show optimal-ticks

  ; reset time state
	reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; set a bunch of turtle variables

;to test


;end


to initialize

  let b 2 *  work-mean + 1
  set work random b
  set working false

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  set itinerary (patches with [space > 0])

;   set itinerary most itinerary
;   set itinerary proximity itinerary
   set itinerary perc-taken itinerary

  ; this doesn't work because run result can't use arguments to the reporter if the reporter is a string
  ;set itinerary (runresult search-type itinerary) ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  set target item 0 itinerary
  set itinerary remove-item 0 itinerary
  set origin patch-here
  if patch-here != target
  [
  set heading towards target
  ]

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; describe process for "running" model

to go

	; tell turtles to do their thing
	ask turtles
	[
		move
	]
  ; update search distance
  ; update occupancy
  ; update search time
  ; update total work accomplished

  ; show "work done so far: "

  ; show work-done
  ; show "total work to be done"
  ; show total-work

;  patch-status
  set total-occupants (sum [occupants] of patches)
;  patch-summary

  if count turtles = 0
  [
    ; show "work done all turtles returned to origin"
    stop
  ]

	; set time constraint
  if ticks >= 10000	[stop]	; need limiting value

end



to patch-status

  ask patches with [space > 0]
  [
    ; show (count turtles-here)
    let turtle-gang turtles-here with [working = true]
    set occupants (count turtle-gang)
    set ratio (([space] of self - [occupants] of self ) / [space] of self)
  ]

end

; for debugging
;to patch-summary
;  set total-occupants (sum [occupants] of patches)
;  show "total space"
;  show total-space
;  show "total occupied space"
;  show total-occupants
;  set percentage-occupied round (total-occupants / total-space)
;  show "percentage occupancy"
;  show (percentage-occupied)
;end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; decribe what turtles are supposed to do while "moving"
to move

  patch-status

  ; if work-remaining > 0:
  ifelse work > 0
  [
    ; show "work remaining"
    ; show work

    ifelse working = false
    [
      ; show "not working"

      ifelse target = nobody
      [
        ; show "target is empty"

        ifelse itinerary = []
        [
          ; show "itinerary is empty"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

          ; set itinerary most itinerary
          set itinerary (patches with [space > 0])

;          set itinerary most itinerary
;          set itinerary proximity itinerary
          set itinerary perc-taken itinerary

          ; runresult doens't accept parameter arguments
          ;set itinerary (runresult search-type itinerary)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          set target item 0 itinerary
          set itinerary remove-item 0 itinerary
        ]
        [
          ; else (if itinerary is not 0)

          ; show "changing target to next item on itinerary"

          set target item 0 itinerary
          ; show target
          set itinerary remove-item 0 itinerary
        ]

        action

        ; set target study patch according to search function
        ; set heading toward that patch
        ; move (<= one "step") toward target-patch
      ]
      [     ; else (if target is set)
        action
      ]
    ]
    [
      ; else (if working is true)

      set work (work - 1)
      set work-done (work-done + 1)
    ]
  ]
  [  ; else (if work remaining is 0)

    ; show "done with work"

    ifelse patch-here = origin
    [
        die
    ]
    [
      ; else (if not at origin patch)

      set target origin

      action
    ]
  ]

end


to action

        ; show "target is set"
        ; show target

        let i 0
        while [i < step-size]
        [
          ifelse patch-here = target
          [
            ; exit while
            set i step-size

            ifelse space-check patch-here
            [
              ; show "space found"
              set working true
            ]
            [ ; else (if there is no space)
              ; show "no space here"

              set target nobody
            ]
          ]
          [ ; else (if current patch is target)
            ; show "target exists"

            set heading towards target
            fd 1
            set i (i + 1)
          ]
        ]    ; end while

end


to-report space-check [patch-of-turtle]

  let x [space] of patch-of-turtle
  let y [occupants] of patch-of-turtle

  ; show "space check: total patch space:"
  ; show x
  ; show "space check: total space occupants:"
  ; show y

  ifelse ([space] of patch-of-turtle) > ([occupants] of patch-of-turtle)
  [
    ; show "space check: this patch is not full commence studying"
    report true

  ]
  [
    ; else (if there isn't space)
    ; show "space check: this patch is full, find another"
    report false
  ]
end

;to-report optimal
;
;  set total-work sum [work] of turtles
;  let h total-work mod total-space
;  let time ( ( total-work - h ) / total-space ) + 1
;  let max-work max [work] of turtles
;
;  report max (list max-work time)
;
;end

; functions below report lists of place patches orderd by various characteristics

; sort sorts smallest to largest so * -1 used where necessary

to-report proximity [a]

  ; show "sort on proximity"

  ; sets turtle target patch as the closest patch with possible space
  let sorted-patches sort-on [ (distance myself) ] a
  ; show sorted-patches
  report sorted-patches

end

to-report most [a]

  ; sets turtle target toward patch with max space
  ; let place-list list patches with [space > 0]

  let ordered-a sort-on [(-1) * space] (a)

  ; let list-a sort-on [space] (patches with [space > 0] )

  report ordered-a

end

to-report perc-taken [a]

  ; sort on total space or percentage space available
  ifelse total-occupants = 0
  [
    let ordered-a sort-on [(-1) * space] (a)
    report ordered-a
  ]
  [
    let ordered-a sort-on [(-1) * ratio] (a)
    report ordered-a
  ]

  ; let a-perc ( ( [space] of a ) / ([occupancy] of a))

end

; sort by absolute number of seats available
to-report availability [a]

  let sorted-patches sort-on [ ( space - occupants ) ] a
  report sorted-patches

end

to weighted

  ; set turtle target toward patch with best combined proximity + space
  ; could allow user to set the weighting...
  ; not enough time, too complicted to do a parameter sweep anyway

end
@#$#@#$#@
GRAPHICS-WINDOW
210
21
927
739
-1
-1
6.39
1
10
1
1
1
0
0
0
1
-55
55
-55
55
0
0
1
ticks
30.0

SLIDER
16
62
188
95
spaces
spaces
0
5000
83.0
1
1
NIL
HORIZONTAL

SLIDER
16
115
188
148
places
places
0
50
30.0
1
1
NIL
HORIZONTAL

SLIDER
20
760
904
793
students
students
0
5000
2000.0
10
1
NIL
HORIZONTAL

SLIDER
17
225
189
258
work-mean
work-mean
0
500
30.0
10
1
NIL
HORIZONTAL

PLOT
1378
186
1578
336
Work Histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

PLOT
1420
495
1620
645
space histogram
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

BUTTON
34
333
96
372
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
35
386
98
419
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
17
279
189
312
step-size
step-size
1
30
10.0
1
1
NIL
HORIZONTAL

BUTTON
39
432
118
465
Go Once
Go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## Overview

### Purpose (1)

This model uses assumptions about how students search for study space and information from the UCL campus to build an environment for studying how information changes search costs. It is inspired by the UCLGo study space app.


### Entities state variables and scales (2)

The model consists of students, study space patches in the center of the environment and tube stops around the perimeter.

#### Each student has
number of ticks they must occupy a study space.
boolean state that is either ``studying" or ``searching''.
a target location that they intend to search next. 
an origin location they come from and return to.

#### Each patch has 
a capacity
a current occupancy value

The size of the environment will reflect the travel times across UCL relative to the density of study spaces. For example, walking from Russell Square Station to Warren Street Station (the diameter of campus) takes about 15 minutes while a student can view majority of the 647 study spaces in the new Student Centre in about 6 minutes. Thus turtles should traverse the environment in 15 ticks and search 100 spaces per tick. 

Thus calibration involves matching travel time to library-patch density to spaces per individual patch.

### Process overview and scheduling (3)


    for each turtle: 
        if work-remaining > 0:
            if state-boolean != studying:
                if target-patch == NULL:
                    set target study patch according to search function
                    set heading toward that patch
                    move (<=  one "step")  toward target-patch
                else:
                    move (<=  one "step")  toward target-patch                
    
                if turtle current patch == a study patch: 
                    if other turtles on current  patch < patch-capacity:
                        boolean = studying
                        patch-occupancy = patch-occupancy + 1
            else:
                set turtle work-remaining = work remaining - 1
        else: 
            if current patch == origin patch: 
                turtle die
            else:         
                set headin and target-patchg to origin tube station
                take max step 





#### Design choices include: 

The boolean allows a turtle to occupy a patch in order to search it without the program treating it as a studying turtle. 

Applying each step above to one turtle at a time allows a turtle to  occupy a space that has been left by another turtle earlier in the  procedure for that same tick. 

Turtle action is ordered according to Netlogo default. This affects the search time for an individual turtle (earlier moving turtles are ``luckier") but it is not a factor on system outcomes as the distribution of search times across turtles is not of interest.


Turtles never wait for space to become available on a patch, students have not been observed waiting, as any waiting space becomes informal study space. 


## Design Concepts (4)

#### Basic principles

The basic concept is a comparison basic and informed search methods. 

A model without explicit space could serve this investigation, adding times according to turtle choice. However,  to think through the design process and illustrate the search and distribution of study space relative to travel, the model does use explicit space.

Reviewing literature for the research proposal found little information on relevant search methods in ABM.  This investigation therefore uses a comparison of different methods (detailed in 3.2 Submodels) to establish which base method should be compared to the method incorporating additional information. Across parameter values, outcomes for models with all turtles using one of the various methods will be compared.

#### Emergence

There is little or no emergence in this model. Incomplete occupancy has been observed in the sense that even at peak times at central study areas not all seats are taken. It is thought that this is an emergent phenomenon in the sense that it is a result of social norms about personal space and control of resources. A good search function would reproduce this but the author has not been able to concieve of a mechanism, without writing the result into the code explicitly in the form of a heuristic or error term.

#### Prediction

The additional information model could increase search times by directing all turtles to patches that will be occupied before they arrive. In the model and real life, agents have to predict if current space will be occupied when they arrive. Perhaps the search function should be a function of space available and relative distance. 

#### Interaction

Interaction occurs through competition for study space, turtles can occupy any of the same patches in the environment and information is not shared between turtles.  

#### Stochasticity

The distribution of study space will be set stochastically according to averages set by the user according to empirical observations of a real space like UCL. This will take the form of a specified number of clusters of individual patches each with a random capacity. 

For example, a model could have 6 clusters, with a number of patches taken randomly from a poisson distribution with $\lambda$ = 10, where each patch has capacity taken from a poisson distribution with  $\lambda$ = 30. This would give an average model run with 300 spaces per cluster on average and 1,800 spaces total. Calibrating this part of the model is a key part of th empirical investigation of UCL study space distribution. 

Turtles will be initialized with a random amount of work to accomplish following a Poisson distribution and at a randomly selected location taken from the set of tube station locations according to a uniform distribution. The Poisson distribution is specified based on the meaninglessness of negative values across the system but there is no empirical basis for assuming that the mean of any of the parameters should equal the variance. 

#### Observation

Values collected each run are: 
- total study time completed
- total turtle search time
- total turtle distance traveled

#### Values collected for each tick are:
- turtle study time remaining
- turtle study time completed
- % study space occuppied


## Details

#### Initialization (5)

Library patches and capacities are distributed as described in the section on stochastic processes. 

A number of turtles sprout at one of five ``tube station'' origins with a randomly assigned amount of work. 

The warm up period required to reach equillibrium where all work is completed and turtles have returned to origin is the period of interest. 


### Submodels (7)

#### Various search functions are used. 

- biggest to smallest
- nearest to farthest 
- percentage available

To move, a while loop is used which continues to loop and add one to the counter until the "step-size" parameter has been reached or the turtle has arrived at a study patch, ending the loop. 

Turtles decide their destination at tick 0 and then each time they reach a destination without study space. Only on these ticks is the search function used so they do not change course on the way to a given patch. 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="5" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>timer</metric>
    <metric>ticks</metric>
    <metric>total-occupants</metric>
    <metric>total-space</metric>
    <metric>work-sum</metric>
    <metric>total-work</metric>
    <enumeratedValueSet variable="step-size">
      <value value="5"/>
      <value value="8"/>
      <value value="10"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spaces">
      <value value="2500"/>
      <value value="3000"/>
      <value value="3500"/>
      <value value="4000"/>
      <value value="4500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="students">
      <value value="15000"/>
      <value value="17500"/>
      <value value="20000"/>
      <value value="25000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="places">
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
      <value value="60"/>
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="work-mean">
      <value value="30"/>
      <value value="45"/>
      <value value="60"/>
      <value value="90"/>
      <value value="120"/>
      <value value="180"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Basic 2" repetitions="20" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>timer</metric>
    <metric>total-occupants</metric>
    <metric>total-space</metric>
    <metric>work-done</metric>
    <metric>total-work</metric>
    <enumeratedValueSet variable="step-size">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spaces">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="students">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="places">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="work-mean">
      <value value="60"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Basic 1" repetitions="20" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>timer</metric>
    <metric>total-occupants</metric>
    <metric>total-space</metric>
    <metric>work-done</metric>
    <metric>total-work</metric>
    <enumeratedValueSet variable="step-size">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spaces">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="students">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="places">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="work-mean">
      <value value="60"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Basic 3" repetitions="20" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>timer</metric>
    <metric>total-occupants</metric>
    <metric>total-space</metric>
    <metric>work-done</metric>
    <metric>total-work</metric>
    <enumeratedValueSet variable="step-size">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spaces">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="students">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="places">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="work-mean">
      <value value="30"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Basic 4" repetitions="20" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>timer</metric>
    <metric>total-occupants</metric>
    <metric>total-space</metric>
    <metric>work-done</metric>
    <metric>total-work</metric>
    <enumeratedValueSet variable="step-size">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spaces">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="students">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="places">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="work-mean">
      <value value="30"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Basic 5" repetitions="20" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>timer</metric>
    <metric>total-occupants</metric>
    <metric>total-space</metric>
    <metric>work-done</metric>
    <metric>total-work</metric>
    <enumeratedValueSet variable="step-size">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spaces">
      <value value="125"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="students">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="places">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="work-mean">
      <value value="30"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Basic 6" repetitions="20" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>timer</metric>
    <metric>total-occupants</metric>
    <metric>total-space</metric>
    <metric>work-done</metric>
    <metric>total-work</metric>
    <enumeratedValueSet variable="step-size">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spaces">
      <value value="83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="students">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="places">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="work-mean">
      <value value="30"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
