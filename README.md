# SSVEP_paradigm
EEG session
========================================================
1. block design, 8 blocks in total, 2 blocks of trained conditions interleave with 2 blocks of untrained conditions 
2. breaks between every blocks, screen shows "press any key to continue", once pressed, show "wait for your experimenter to start next run", after key press is detected on the experimenter keyboard, start next block.
3. diagnostic features flashing at 15Hz, non diagnostic features at 20Hz
4. subnum determines which training condition s/he was on, generate the corresponding EEG experiment condition according to his/her training condition. For example, subnum 2 was trained on horses, untrained on humans, for horses, head/beard/leg were the diagnostic features, body/mane/tail were non diagnostic. Then in the EEG experiment, generate first 2 blocks with trained exemplars which are horses, then make the three diagnostic features flashing at 15Hz, the other three features flash at 20Hz.
5. prompt window at the start of the EEG experiment, asking experimenter to input the following information: subnum, sub initials, date of the experiment.
7. keep a record of which 6 features each exemplar appears in the EEG experiment has, make a list of the features following the sequence of the exemplars appeared in the experiment, out put to a file named in the format OBSSEEG_(subnum)(sub initials).txt
8. response key set to J. pause key set to esc.
9. sequence of a trial: fixation cross at the center of the screen (100ms) stimuli (300ms) cue (3 parts turning red) (100ms) if probe appear, appears for (100ms)
10. record key press response, response time after the end of probe onset, which key is pressed, out put to the above file
