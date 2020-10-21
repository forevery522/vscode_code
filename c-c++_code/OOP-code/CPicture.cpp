#include<iostream>
#include<cstdlib>
#include<cstdio>
#include<cstring>
using namespace std;

class CPicture
{
	bool m_bStatiate;
	char m_szName[20];
public:
	CPicture(char* szName = NULL);
	CPicture(CPicture& CopyPicture);
	char* GetName()
	{
		return m_szName;
	}
	void show() { m_bStatiate = true; }
	void Finish()
	{
		if (m_bStatiate)
		{
			cout << "so beautiful this picture is" << endl;
		}
		else
		{
			cout << "what's the beginning time?" << endl;
		}
	}
	~CPicture();
};

CPicture::CPicture(char* szName)
{
	m_bStatiate = false;
	if (szName == NULL)
	{
		cout << " I have no name yet." << endl;
		m_szName[0] = '\0';
	}
	else
	{
		strcpy(m_szName, szName);
		cout << "I am" << m_szName << ", a beautiful picture." << endl;
	}
}

CPicture::CPicture(CPicture &CopyPicture)
{
	m_bStatiate = false;
	strcpy(m_szName, CopyPicture.GetName());
	strcat(m_szName, "copy");
	cout << "I am" << m_szName << ", also a picture." << endl;
}

void Begin(CPicture Picture)
{
	Picture.show();
}

CPicture::~CPicture()
{
	cout << "it's close" << m_szName << "time to leave." << endl;
}

int main()
{
	CPicture Picture("sun rise.");
	Begin(Picture);
	Picture.Finish();
	return 0;
}