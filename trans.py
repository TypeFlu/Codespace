from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, pipeline

# Best model with balance of speed + accuracy
model_name = "facebook/nllb-200-distilled-600M"

def load_translator(src_lang, tgt_lang):
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForSeq2SeqLM.from_pretrained(model_name)
    translator = pipeline("translation", model=model, tokenizer=tokenizer, src_lang=src_lang, tgt_lang=tgt_lang)
    return translator

def main():
    print("🌐 NLLB-200 Translator | English ↔ Chinese")
    print("Languages: eng_Latn (English), zho_Hans (Simplified Chinese), zho_Hant (Traditional Chinese)\n")

    src_lang = input("From (e.g., eng_Latn): ").strip()
    tgt_lang = input("To   (e.g., zho_Hans): ").strip()
    text = input("Enter text to translate:\n> ").strip()

    translator = load_translator(src_lang, tgt_lang)
    result = translator(text, max_length=400)[0]['translation_text']

    print("\n✅ Translated:")
    print(result)

if __name__ == "__main__":
    main()
