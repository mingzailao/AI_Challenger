#! /bin/sh

#Download the dataset and put the dataset in ../raw_data file


MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $MYDIR
DATA_DIR=$MYDIR/../../../../data

#unwrap xml for valid data and test data
python $MYDIR/prepare_data/unwrap_xml.py $DATA_DIR/valid.en-zh.zh.sgm >$DATA_DIR/valid.en-zh.zh
python $MYDIR/prepare_data/unwrap_xml.py $DATA_DIR/valid.en-zh.en.sgm >$DATA_DIR/valid.en-zh.en

#Prepare Data

##Chinese words segmentation
python $MYDIR/prepare_data/jieba_cws.py $DATA_DIR/train.zh > $DATA_DIR/train.tok.zh
python $MYDIR/prepare_data/jieba_cws.py $DATA_DIR/valid.en-zh.zh > $DATA_DIR/valid.tok.zh
## Tokenize and Lowercase English training data
cat $DATA_DIR/train.en | $MYDIR/prepare_data/tokenizer.perl -l en | tr A-Z a-z > $DATA_DIR/train.tok.en
cat $DATA_DIR/valid.en-zh.en | $MYDIR/prepare_data/tokenizer.perl -l en | tr A-Z a-z > $DATA_DIR/valid.tok.en

#Bulid Dictionary
python $MYDIR/prepare_data/build_dictionary.py $DATA_DIR/train.en
python $MYDIR/prepare_data/build_dictionary.py $DATA_DIR/train.zh
src_vocab_size=50000
trg_vocab_size=50000
python $MYDIR/prepare_data/generate_vocab_from_json.py $DATA_DIR/train.en.json ${src_vocab_size} > $DATA_DIR/vocab.en
python $MYDIR/prepare_data/generate_vocab_from_json.py $DATA_DIR/train.zh.json ${trg_vocab_size} > $DATA_DIR/vocab.zh
rm -r $DATA_DIR/train.*.json
