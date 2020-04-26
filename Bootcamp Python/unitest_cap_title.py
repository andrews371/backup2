import unittest
import cap_title

class TestCap_Title(unittest.TestCase):

	def test_one_word2(self):
		text = 'python'
		result = cap_title.test_cap_title(text)
		self.assertEqual(result, 'Python')

	def test_multiple_words(self):
		text = 'monty python'
		result = cap_title.test_cap_title(text)
		self.assertEqual(result, 'Monty Python')

if __name__=='__main__':
	unittest.main()