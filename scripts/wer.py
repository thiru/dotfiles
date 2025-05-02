#!/usr/bin/env python

"""Print WER (word error rate) of given files. Uses https://github.com/jitsi/jiwer"""

from pathlib import Path
import sys
import jiwer

if len(sys.argv) != 3:
    sys.stderr.write('Usage: wer.py base_file compare_file\n')
    sys.exit(1)

ground_truth = Path(sys.argv[1]).read_text(encoding='UTF-8')
hypothesis = Path(sys.argv[2]).read_text(encoding='UTF-8')

#print(ground_truth)
#print(hypothesis)

transformation = jiwer.Compose([
    jiwer.Strip(),
    jiwer.ToLowerCase(),
    jiwer.RemovePunctuation(),
    jiwer.RemoveWhiteSpace(replace_by_space=True),
    jiwer.RemoveMultipleSpaces(),
    jiwer.ReduceToListOfListOfWords(word_delimiter=" ")
])

error = jiwer.wer(
    ground_truth,
    hypothesis,
    truth_transform=transformation,
    hypothesis_transform=transformation
)

print('WER:', error)
