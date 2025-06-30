# translator_nllb.py
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, pipeline
import sys

MODEL = "facebook/nllb-200-distilled-600M"  # or -1.3B for higher quality

def main():
    src = input("Source (e.g. eng_Latn or zho_Hans): ").strip()
    tgt = input("Target (e.g. zho_Hans or eng_Latn): ").strip()
    text = input("Text to translate:\n").strip()

    tokenizer = AutoTokenizer.from_pretrained(MODEL)
    model = AutoModelForSeq2SeqLM.from_pretrained(MODEL)

    translator = pipeline(
        "translation",
        model=model,
        tokenizer=tokenizer,
        src_lang=src,
        tgt_lang=tgt,
        device=-1  # CPU
    )
    out = translator(text, max_length=512)[0]['translation_text']
    print("\n✅ 翻译结果：\n", out)

if __name__ == "__main__":
    main()
