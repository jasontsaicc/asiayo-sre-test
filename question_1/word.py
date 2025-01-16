with open('words.txt', 'r') as file:
    text = file.read()

# 轉小寫並移除標點符號
import string
text = text.lower()  
text = text.translate(str.maketrans('', '', string.punctuation))  # 移除標點符號

# 第三步：將文章拆成單字
words = text.split()

# 第四步：統計單字出現次數
word_count = {}
for word in words:
    if word in word_count:
        word_count[word] += 1
    else:
        word_count[word] = 1

# 第五步：找出出現次數最多的單字
most_frequent_word = None
max_count = 0
for word, count in word_count.items():
    if count > max_count:
        most_frequent_word = word
        max_count = count

# 第六步：輸出結果
print(f"{max_count} {most_frequent_word}")
