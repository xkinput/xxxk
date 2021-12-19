Function Ŀ¼
# ��������
#     Ԥ���壺ͷ�ļ�(!include)��ҳ�����ԡ����������ε�
#     �����̣�.onInit��������ӭҳ����Ȩҳ��·��ҳ(��������$INSTDIR)��.onVerifyInstDir����(��������$yongdir)�����ҳ�������Ρ���ʼ�˵�ҳ(������)������ҳ�����ҳ��.onInstSuccess����
#
# ����
#     ���壺�����ں�����֮��ĵط����塣���庯������Function�ؼ��֣�����Section�ؼ��֣�һ������ĺ������ֳ�Ϊ���Σ���
#     ���ã�Section�ᱻ�������Զ����ã�Function�򣨶�����ֻ���ں������ڵ��á�
#
# �����ͳ���
#     ���壺�������κεط����壬������������Var /GLOBAL myvar��������������!define myconst "ֵ"�������ͳ�������ȫ�ֵġ�
#     ��ֵ��������ֵ����ʹ��Pop��StrCpy�Ⱥ����ı䡣
#     ���ã�������$��������������${������}
#     ������ϵͳԤ������һЩ��������ֱ��ʹ�ã�����$0��$INSTDIR�ȣ��μ���NSIS�û��ֲᣯ4.2.2 ������д�ı�������
#     ҲԤ������һЩ��������������$PROGRAMFILES�ȣ��μ���NSIS�û��ֲᣯ4.2.3 ������
FunctionEnd
#
# ���ú���
# IfFileExists path a b������ļ����ڣ�����ת��a��������ת��b����ת������Ǳ��(lbl:),���Ե�ǰ��Ϊ0������к�(+x, -x)
# CreateShortCut ��ݷ�ʽ·��.lnk Ŀ���ļ� [���� [ͼ���ļ� [ͼ�������� [����ѡ�� [���̿�ݼ� [����]]]]]]
# Delete��ɾ���ļ���ע�ⲻ��ɾ��Ŀ¼
# RMDir /r��ɾ��Ŀ¼��û��/r����ʱֻ����Ŀ¼Ϊ��ʱ�Żᱻɾ�������ָ����/r����Ŀ¼����Ŀ¼���ļ����ᱻ����ɾ�������ָ����/REBOOTOK����ɾ��ʧ�ܵ��ļ���������ᱻɾ��
# Rename Դ�ļ�·�� Ŀ���ļ�·����Ҳ������ͬһ�̷����ƶ�Ŀ¼�����Ŀ���ļ��Ѵ��ڻ���Ŀ���ļ���Ŀ¼�����ڣ��ᵼ���ƶ�ʧ��
# CopyFiles /SILENT Դ�ļ�·�� Ŀ��Ŀ¼·�������Ʋ������ļ�
# StrCpy $0 "hello" N1 N2 ���ַ�����������������N2λ��Ȼ���ȡN1λ��Ĭ��""��ʾ��ȡ��β���������浽$0
# StrCmp $0 $R0 +1 +2 �Ƚ������ַ���$0��$R0�����ִ�С���������������+1������������+2��
# IntCmp����
# IntOp ��������
# ReadRegStr ����-��-������ע����ֵ�������У��������ڣ������Ϊ�ղ������ô�����Errors
# ExecShell "open" "${PRODUCT_WEB_SITE}" ������ҳ
# ExecShell "open" "$INSTDIR\tools\bat\yong.bat" ���г���
# MessageBox MB_OK $INSTDIR

Function Ԥ���壺ͷ�ļ�
#    ������ע��
FunctionEnd
!include "MUI2.nsh"
#!include "TextFunc.nsh"
!include "x64.nsh" # �ж�ϵͳλ����������${If} ${RunningX64} ... ${Else} ... ${EndIf}�ж�λ������${DisableX64FSRedirection}�ر�64λϵͳ��·���ض���32λ
!include "LogicLib.nsh" # ���ƽṹ���жϺ���֧�֣��ο�https://nsis.sourceforge.io/LogicLib
!include "WinVer.nsh" # �ж�ϵͳ�汾���÷�http://nsis.sourceforge.net/Get_Windows_version
!include "FileFunc.nsh" # �ļ���������${Locate}����·�������μ��û��ֲ�
!include "EnumIni.nsh" # ini�ļ����ݱ���

Function Ԥ���壺һЩ����
#    ������ע��
FunctionEnd
!define AppName "xxxk"
!define PRODUCT_NAME "СС�ǿ�"
!define PRODUCT_VERSION "1.0.4.0"
!define PRODUCT_VERSION_MINOR "20211219"
!define PRODUCT_PUBLISHER "thXnder"
!define PRODUCT_WEB_SITE "http://xkinput.github.io/xxxk-help"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

Function Ԥ���壺��װ������
#    �μ���NSIS�û��ֲᣯ4.8 ��װ�������ԡ�
FunctionEnd
RequestExecutionLevel admin # �������ԱȨ��
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf" # Select Lang
# ��װ�������ֵȻ�����Ϣ
Name ${PRODUCT_NAME}
SetCompressor /FINAL /SOLID lzma # ���ð�װ��ѹ����ʽ
OutFile "${PRODUCT_NAME}���뷨-v${PRODUCT_VERSION}-Build${PRODUCT_VERSION_MINOR}.exe" # ��װ��������
# ��װ���ļ�������İ汾��Ϣ
VIProductVersion "${PRODUCT_VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "dgod"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"
# ��װ����һЩ���涨��
InstallDir $PROGRAMFILES\${AppName} # ��Ĭ�ϰ�װ·����$PROGRAMFILES����64λϵͳΪ"C:\Program Files (x86)"������32λ����"C:\Program Files"�������$PROGRAMFILES64����ô������ϵͳ����"C:\Program Files"
InstallDirRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" # ��ȡ�ɰ汾�İ�װ·��
BrandingText ${PRODUCT_NAME}-${PRODUCT_WEB_SITE}
XPStyle on
ShowInstDetails show
DetailsButtonText "��ʾϸ��"
CompletedText "��װ���"

Function Ԥ���壺ҳ������
#     �μ���NSISͼ�Ľ̳̼�����������Modern UI�̡̳�
FunctionEnd
# ȫ���趨
!define MUI_ABORTWARNING
!define MUI_ICON "skin\favicon.ico"
#
# ��ӭҳ���ԣ�
# !define MUI_WELCOMEPAGE_TITLE "��ӭʹ��"
# !define MUI_WELCOMEPAGE_TEXT  "СС�ǿա���$\r$\n$\r$\n    ����СС���뷨ƽ̨��$\r$\n$\r$\n    �ǿ�ϵ�����뷨��װ$\r$\n$\r$\n    "
# !insertmacro MUI_PAGE_WELCOME
#
# ��Ȩҳ
!define MUI_PAGE_HEADER_TEXT "��ӭʹ��"
!define MUI_PAGE_HEADER_SUBTEXT "СС�ǿա�������СС���뷨ƽ̨���ǿ�ϵ�����뷨��װ"
!define MUI_INNERTEXT_LICENSE_TOP "�ڼ�����װ֮ǰ������ϸ�Ķ����������ȨЭ�飺"
!define MUI_INNERTEXT_LICENSE_BOTTOM "��������������ġ��ҽ��ܡ���ť��������װ������������������ȨЭ�顣"
!insertmacro MUI_PAGE_LICENSE "README.txt"
#
# ·��ҳ
!define MUI_PAGE_HEADER_TEXT "��װ·��"
!define MUI_DIRECTORYPAGE_TEXT_TOP "��ѡ��${PRODUCT_NAME}�İ�װ·��"
!define MUI_DIRECTORYPAGE_VARIABLE $INSTDIR # ������䣬��װ·���ͻᱻ���浽$INSTDIR������
!insertmacro MUI_PAGE_DIRECTORY
#
# ���ҳ
!define MUI_PAGE_HEADER_TEXT "���ѡ��"
!define MUI_PAGE_HEADER_SUBTEXT "���ư�װѡ��"
!insertmacro MUI_PAGE_COMPONENTS

#
# ��ʼ�˵�ҳ
# ���ԣ�
#
# ����ҳ
!define MUI_PAGE_HEADER_TEXT "���ڰ�װ"
!insertmacro MUI_PAGE_INSTFILES
#
# ���ҳ
!define MUI_FINISHPAGE_TITLE "��װ���"
!define MUI_FINISHPAGE_TEXT_LARGE
!define MUI_FINISHPAGE_TEXT "СС�ǿ���Ҫ���п�ʼ�˵������Ŀ¼�µġ�СС�ǿա���ݷ�ʽ�����ʹ�á�$\nΪ��ʹ�÷��㣬��Ϊ����ӿ���������������ȷ�ϡ�"
!define MUI_FINISHPAGE_RUN # ����ֱ�����г��򣬾�!define MUI_FINISHPAGE_RUN xxx.exe������Ҫ�����RUN_FUNCTION
!define MUI_FINISHPAGE_RUN_FUNCTION RunXxxk # ��װ��ɺ�ִ��ָ������
!define MUI_FINISHPAGE_RUN_TEXT "������������ СС�ǿ�"
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "��Ҫ��ӿ����������������鹴ѡ��"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION DelStartup
!define MUI_FINISHPAGE_LINK '�Ķ� ʹ��˵��'
!define MUI_FINISHPAGE_LINK_LOCATION ${PRODUCT_WEB_SITE} #$INSTDIR\doc\����\ССС�ǿ����뷨�û��ֲ�.html
!insertmacro MUI_PAGE_FINISH
# ж��ȷ��ҳ���ԣ�
# !insertmacro MUI_UNPAGE_CONFIRM
#
# ����ҳ���ԣ�
!insertmacro MUI_LANGUAGE "SimpChinese" ; �����������԰���NSIS\Contrib\Language files\SimpChinese.nsh��
# !insertmacro MUI_LANGUAGE "English"
# !insertmacro MUI_RESERVEFILE_LANGDLL

Function Ԥ���壺һЩ����
# ע�⣺Ϊ����Ĵ�����ͻ�����ű���$0��$9�������Σ�$R0��$R9���ں������ڵ��ú�����$R0��$R9��ֵ���ܻ��
FunctionEnd
#
Function RunXxxk
		ExecShell "open" "$INSTDIR\tools\bat\rerun.bat"
Functionend
Function DelStartup ; ȡ������������ֻ���ڰ�װ�棬��Ұ治�ᰲװ�����
		Delete "$SMSTARTUP\yong.lnk"
Functionend
#
Function SetSecChk
# ���ܣ���ѡ/ȡ����ѡĳһ����
# ���������
    Pop $R1 # �Ƿ�ѡ��1��0��
		Pop $R0 # ${���α�ǩ}��id��ע����������Ҳ����id��
# �����������
# ԭ����SectionGetFlags ���� ���������Զ�ȡ����Flags����SectionSetFlags ���� Flags��������������Flags�����ε�Flags��һ����λ��������λ�ֱ��в�ͬ���壺
# ��1λ���Ƿ�ѡ�У�����λ����ʱ��Ӧ��FLagsΪ${SF_SELECTED}
# ��2λ���Ƿ����飬����λ����ʱ��Ӧ��FLagsΪ${SF_SECGRP}
# ��4λ���Ƿ�Ӵ���ʾ������λ����ʱ��Ӧ��FLagsΪ${SF_BOLD}
# ��5λ���Ƿ�ֻ��������λ����ʱ��Ӧ��FLagsΪ${SF_RO}
# ��6λ���������Ƿ�չ��������λ����ʱ��Ӧ��FLagsΪ${SF_EXPAND}
# ��7λ���������Ƿ񲿷�ѡ�У�����λ����ʱ��Ӧ��FLagsΪ${SF_PSELECTED}
    SectionGetFlags $R0 $R2 # �����ε�Flags����$R2
    IntOp $R2 $R2 & 0       # ����Flags������λ��
    IntOp $R2 $R2 | $R1     # �����µ�1λ���Ƿ�ѡ�У�
    SectionSetFlags $R0 $R1 # �������ε�Flags
Functionend
# ���ú�򻯸ú����ĵ��÷�ʽΪ����!insertmacro SetSecChk ${����} �Ƿ�ѡ��
!macro SetSecChk Sec isChecked
	Push ${Sec}
	Push ${isChecked}
	Call SetSecChk
!macroend
#
Function GetSecChk
# ���ܣ���ȡĳһ���ε�ѡ��״̬
# ���������
		Pop $R0 # ${���α�ǩ}��id��ע����������Ҳ����id��
# ���������Push 1/0
    SectionGetFlags $R0 $R2 # �����ε�Flags����$R2
    IntOp $R2 $R2 & 1       # ������Flags�ĵ�1λ���Ƿ�ѡ�У�
    Push $R2
Functionend
# ���ú�򻯸ú����ĵ��÷�ʽΪ����!insertmacro GetSecChk ����ֵ���� ${����}��
!macro GetSecChk isChecked Sec
	Push ${Sec}
	Call GetSecChk
	Pop ${isChecked}
!macroend
#
Function IsParentDir
# ���ܣ��ж�Ŀ¼0�Ƿ�ΪĿ¼1�ĸ�Ŀ¼
# ���������
		Pop $R1 # Ŀ¼1��������Ŀ¼��
		Pop $R0 # Ŀ¼0�����Ƹ�Ŀ¼��
# ���������Push 1/0
		StrLen $R2 $R0       # Ŀ¼0�ĳ��� �� $R2
		StrCpy $R3 $R1 $R2   # Ŀ¼1��ǰ�벿�� �� $R3
		StrCpy $R4 $R1 1 $R2 # Ŀ¼1��ǰ�벿�ֵ���һ���ַ� �� $R4

		${If}   $R4 == "\"
		${OrIf} $R4 == "/"
		${OrIf} $R4 == ""
		${AndIf} $R3 == $R0
		    Push 1
		${Else}
    		Push 0
		${EndIf}
FunctionEnd
# ���ú�򻯸ú����ĵ��÷�ʽΪ����!insertmacro IsParentDir ����ֵ���� Ŀ¼0 Ŀ¼1��
# ע�⣺!insertmacro����ʱ�����������ݺ��ո�����븳ֵ������������꣬����ֱ�Ӱ����ݸ���
!macro IsParentDir isParent Dir0 Dir1
	Push ${Dir0}
	Push ${Dir1}
	Call isParentDir
	Pop ${isParent}
!macroend
#
Function CopyINIKey
# ���ܣ�����Դini�е�ָ����ֵ��Ŀ��ini
# ���������
		Pop $R0 # Դini
		Pop $R1 # Ŀ��ini
		Pop $R2 # ����
		Pop $R3 # ����
# �����������
		ReadINIStr $R4 $R0 $R2 $R3  # ��ȡ��ֵ��$R4
		StrCmp $R4 "" 0 +2
		DeleteINIStr $R1 $R2 $R3 # ���ֵΪ�գ���ɾ���ü�ֵ��
		WriteINIStr $R1 $R2 $R3 $R4 # ���ֵ��Ϊ�գ��򸲸Ǹ�ֵ
FunctionEnd
# ���ú�򻯸ú����ĵ��÷�ʽΪ����!insertmacro CopyINIKey Դini Ŀ��ini ���� ������
# ע�⣺!insertmacro����ʱ�����������ݺ��ո�����븳ֵ������������꣬����ֱ�Ӱ����ݸ���
!macro CopyINIKey src dest sec key
		Push ${key} # ����
		Push ${sec} # ����
		Push ${dest} # Ŀ��ini
		Push ${src} # Դini
		Call CopyINIKey
!macroend
#
Function CopyINISec
# ���ܣ�����Դini�У�ָ���������м�ֵ��Ŀ��ini
# ���������
		Pop $R0 # Դini
		Pop $R1 # Ŀ��ini
		Pop $R2 # ����
# �����������
		StrCpy $R3 0 # �������ڼ���������0��ʼ��
		loopBegin:
				${EnumIniValue} $R4 $R0 $R2 $R3 # ��ȡ$R0�ļ���$R2���еĵ�$R3��(��0��ʼ)�������֣���$R4��
				StrCmp $R4 "" loopEnd
				ReadINIStr $R5 $R0 $R2 $R4  # ��ȡ��ֵ��$R5
				WriteINIStr $R1 $R2 $R4 $R5
				IntOp $R3 $R3 + 1
				Goto loopBegin
		loopEnd:
FunctionEnd
# ���ú�򻯸ú����ĵ��÷�ʽΪ����!insertmacro CopyINISec Դini Ŀ��ini ������
# ע�⣺!insertmacro����ʱ�����������ݺ��ո�����븳ֵ������������꣬����ֱ�Ӱ����ݸ���
!macro CopyINISec src dest sec
		Push ${sec} # ����
		Push ${dest} # Ŀ��ini
		Push ${src} # Դini
		Call CopyINISec
!macroend
#
Function VerifyScheduleConfig
# ���ܣ���֤yong.ini�ļ���ĳ�����ֵķ����������ļ���Ч��
# ���������
		Pop $R0 # yong.ini
		Pop $R1 # ��������
# ���������Push 0/1
    Push 1 # Ĭ����Ч
		${Do}
		    ReadINIStr $R2 $R0 $R1 "name"
		    ${If} $R2 == ""
		        Push 0
						${Break}
				${EndIf}
				
		    ReadINIStr $R2 $R0 $R1 "engine"
		    ${If} $R2 == ""
		        Push 0
						${Break}
				${EndIf}
				
		    ReadINIStr $R2 $R0 $R1 "arg"
		    ${If} $R2 == ""
		        Push 0
						${Break}
				${EndIf}
				
				${Break}
		${Loop}
FunctionEnd
# ���ú�򻯸ú����ĵ��÷�ʽΪ����!insertmacro VerifyScheduleConfig ����ֵ���� ini ��������
# ע�⣺!insertmacro����ʱ�����������ݺ��ո�����븳ֵ������������꣬����ֱ�Ӱ����ݸ���
!macro VerifyScheduleConfig isValid ini name
		Push ${name} # ��������
		Push ${ini}  # yong.ini
		Call VerifyScheduleConfig
		Pop ${isValid} # ����ֵ
!macroend
#
Function ������
#    ������ע��
FunctionEnd
#
Function .onInit
#    !insertmacro MUI_LANGDLL_DISPLAY ; ���ҳ�涨���￪���˶����ԣ���Ҫ���������
FunctionEnd
#
Function ��ӭҳ����Ȩҳ��·��ҳ
#    ������ע��
FunctionEnd
#
Function .onVerifyInstDir
		# ���ι��ܣ��ж�СС���뷨��װ���û�ѡ��İ�װĿ¼��$INSTDIR��ʱ��������Ŀ¼.yongĿ¼��·����$yongdir��
		# �ж��߼���ֻҪ$INSTDIR��$PROGRAMFILESĿ¼�£�$yongdir����$APPDATA\yong���������$INSTDIR\.yong����Ұ�СС��һ����$INSTDIR\.yong��
		# ���������Ԥ���峣����$INSTDIR
		# ��س�����$PROGRAMFILES��64λϵͳΪ"C:\Program Files (x86)"������32λ����"C:\Program Files"
		# ���������$yongdir
		Var /GLOBAL yongdir
		!insertmacro IsParentDir $0 $PROGRAMFILES $INSTDIR
		${If} $0 == 1
		    StrCpy $yongdir $APPDATA\yong
		${Else}
		    StrCpy $yongdir $INSTDIR\.yong
		${EndIf}
FunctionEnd
#
Function ���ҳ
#    �����ҳ����ѡ��ʱ�ᴥ��.onSelChange��ѡ����ϵ���һ��ʱ��ִ�и�������Ĵ��롣
FunctionEnd
#
Function .onSelChange

FunctionEnd
#
Function ����
#    ������ע��
FunctionEnd
# ���ξ������ҳ���������û������ҳ��㡸��һ������������������Σ���ѡ�У����ִ������Ĵ���
# �������ε��﷨��
# Section "���α�ǩ" SecName ... SectionEnd��Ĭ�Ϲ�ѡ�����Ρ������α�ǩ��!��ͷ�����Ӵ���ʾ
# Section /o "���α�ǩ" SecName ... SectionEnd��Ĭ�ϲ���ѡ�����Ρ������α�ǩ��!��ͷ�����Ӵ���ʾ
# Section "-���α�ǩ" SecName ... SectionEnd��Ĭ�Ϲ�ѡ����������
# �������εķ�������${SecName}
# �ж������Ƿ�ѡ�У�${SectionIsSelected} ${SecPortable}
# ���������Ƿ�ѡ�У�SectionSetFlags ${SecXkjd6Dic} 0��1
# ������ο��Ա�������������SectionGroup /e "�������ǩ" SecGroupName ... SectionGroupEnd����γɲ�νṹ��/e��ʾĬ��չ�������顣
#
Section /o "��Я��װ�����ģʽ��" SecPortable
		# ����ɶ���������жϸ������Ƿ�ѡ��
SectionEnd

Section /o "�����趨" SecClearUser
		# ����ɶ���������жϸ������Ƿ�ѡ��
SectionEnd

Section /o "[ʵ����]ʹ��64λ�Ľ������" SecX64
		# ����ɶ���������жϸ������Ƿ�ѡ��
SectionEnd

Section "-���ɰ�" SecChkOldVer
		# ���������������ǰ��Ԥ����ĳ���
		# ���������������$oldver
    DetailPrint "������汾..."
    
		Var /GLOBAL uninstpath # �ɰ�ж�س����·��������XXX\uninstall.exe
		Var /GLOBAL oldver     # �ɰ�汾��
		Var /GLOBAL uninstdir  # �ɰ�ж�س�������Ŀ¼
		ClearErrors

		${Unless} ${SectionIsSelected} ${SecPortable} # ��ѡ�С����ģʽ��������²�ִ�����´���

				check_xxjd3:
				ReadRegStr $uninstpath ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\СС����3" "UninstallString"
				IfErrors check_xxjd6
				ReadRegStr $oldver ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\СС����3" "DisplayVersion"
				MessageBox MB_YESNO|MB_ICONQUESTION "��⵽СС����3���汾��$oldver����ע����������ж���������ܼ�����װ��\
				                                     $\n$\nҪ�Ұ���ж����" \
			             /SD IDYES IDYES uninst_xxjd3
				Abort

				uninst_xxjd3:
				StrCpy $uninstdir $uninstpath -13
			  ExecWait '"$uninstpath" /S _?=$uninstdir' $0
			  DetailPrint "uninstall.exe returned $0"
			  Delete "$uninstpath"
			  RMDir $uninstdir

				check_xxjd6:
				ReadRegStr $uninstpath ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\СС����6" "UninstallString"
				IfErrors check_xxxk
				ReadRegStr $oldver ${PRODUCT_UNINST_ROOT_KEY} "Software\Microsoft\Windows\CurrentVersion\Uninstall\СС����6" "DisplayVersion"
				MessageBox MB_YESNO|MB_ICONQUESTION "��⵽СС����6���汾��$oldver����ע����������ж���������ܼ�����װ��\
				                                     $\n$\nҪ�Ұ���ж����" \
			             /SD IDYES IDYES uninst_xxjd6
				Abort

				uninst_xxjd6:
				StrCpy $uninstdir $uninstpath -13
			  ExecWait '"$uninstpath" /S _?=$uninstdir' $0
			  DetailPrint "uninstall.exe returned $0"
			  Delete "$uninstpath"
			  RMDir $uninstdir

				check_xxxk:
				ReadRegStr $uninstpath ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"
				IfErrors exitChk

				ReadRegStr $oldver ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "DisplayVersion"
				MessageBox MB_YESNO|MB_ICONQUESTION "��⵽�����Ѿ���װ�� ${PRODUCT_NAME} $oldver��\
				                                           $\n$\nҪ���������𣿣�����Ŀ¼�µ����ݿ��ܻᱻ���ǣ��������ñ�Ҫ�ı��ݣ�" \
				           /SD IDYES IDYES exitChk  #/SDָ����Ĭ��װģʽ�£��Զ�Ӧ��Ի����ֵ
				Abort
		${EndUnless}

		exitChk:
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecPortable} "���ͷ��ļ�������дע����TSFģ�顣$\r$\n$\r$\n�ʺ������������߰�װ��U�̵��û���$\r$\n$\r$\n��һЩ����ļ��ݲ��ѣ������鹴ѡ��"
!insertmacro MUI_DESCRIPTION_TEXT ${SecClearUser} "�����û������뷨���еĸ��Ի����ã�yong.ini����"
!insertmacro MUI_DESCRIPTION_TEXT ${SecX64} "СС���뷨����������ں˳���ͽ���������У��ں˳���ͨ������32λ��64λ˫ģʽͬʱ���еģ���������������ȶ���32λģʽ���С���ѡ����ɽ�����������Ϊ��64λģʽ���С�" # �����Ƽ���32λ��http://yong.dgod.net/read.php?tid=766��
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSel} "СС�ǿհ���һϵ�����뷽���������ѡ���԰�װ��"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkjd6} "21��˫ƴ+5���ָ��ʻ������ֶ�����ʽ�������߼��򵥣����Ч�ʸ��ߡ�"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkyb} "26��˫ƴ+5���ʻ���˫ƴ���ֳ����򵥣��Դ�ģ������"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkyd} "���̴����Զ��󿪣���һ�ʵ�˫ƴ������ıʻ��ں��������Ƿ��ܼ�����������������"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklb} "25����ĸ+25��˫��+5�����ʣ��ǶԴ�ͳ���ʵĶ������죬���ֺʹ���Ч�ʶ�����"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklbzv} "ȽȽ�������ǿ����ʵĻ����ϰ�Z��V�Ե�����׷������ʵ��ָС�"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklbdz} "��ˣ�������ǿ����ʵĻ����ϣ��������鲢�Ż����ŵ��֣��볤�����������룬�ʺ���ͨ��ʹ�õĴ����ַ�����"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXklbddr} "DR���е��ǿ����ʵ��ְ棬�������鲢�Ż����ŵ��֣�ͬʱ�������������غ������롣"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelPinyin} "��ͨ��ȫƴ��������˵�������ѹ��ơ�"
;!insertmacro MUI_DESCRIPTION_TEXT ${SecSelXkxb} "�ǿ��Ǳ�"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "-������ϵͳ�汾" SecChkOS
		# ���ι��ܣ����ϵͳ�汾������Win8����ϵͳ����֪�û����밲װ��X:\Program Files (x86)��64λϵͳ����X:\Program Files��32λϵͳ����������metro������ʹ��
		# �������������Ԥ���峣����$INSTDIR
		# ���������������
		DetailPrint "������ϵͳ�汾..."
		${IfNot} ${AtMostWin7}
		    !insertmacro IsParentDir $0 $PROGRAMFILES $INSTDIR # �ж�$INSTDIR�Ƿ���$PROGRAMFILES������¼��$0
				StrCmp $0 1 pathIsGood +1
		    MessageBox MB_YESNO|MB_ICONINFORMATION "Win8���ϲ���ϵͳ�����齫$PROGRAMFILES��Ϊ��װ·����\
																						 		$\n����ȻҪ��װ��$INSTDIR������ᵼ�����뷨�޷���MetroӦ����ʹ�á�" \
										/SD IDYES IDYES pathIsGood
				Abort
				pathIsGood:
		${EndIf}
SectionEnd

Section "-�ر�yong.exe" SecChkYong
		# ���ι��ܣ���ֹ�������е�yong.exe
		# �������������Ԥ���峣��
		# ���������������
		DetailPrint "����������еĳ���..."
		loopTerminateBegin:
		FindWindow $0 "yong_main"
		IntCmp $0 0 loopTerminateEnd
		# ����ʾ��ֱ����ֹ
;		MessageBox MB_OKCANCEL "СС���뷨�������������С�\
;							   $\n$\n�����ȷ������ǿ�ƹر�СС���뷨Ȼ�������װ��\
;							   $\n$\n�����ȡ��������ֹ���ΰ�װ��" \
;				   /SD IDOK IDOK NoAbort
;		Abort
;		NoAbort:
		SendMessage $0 2 0 0 # �����ڷ����˳���Ϣ
		# �ԵȺ�������ֱ����ⲻ�����û�ѡ��ȡ��
		Sleep 444
		Goto loopTerminateBegin
		loopTerminateEnd:
SectionEnd

Section "-�ͷ���Ҫ�ļ�" SecInstMainFiles
		# ���ι��ܣ��ͷ���Ҫ�ļ��������Ƿ����ģʽ����Щ�ļ����Ǳ���Ҫ�ͷŵģ�
		# �������������Ԥ���峣����$INSTDIR��$yongdir
		# ���������������
		Detailprint "�ͷ���Ҫ�ļ�..."
		#
		# ��װ64λ�������ļ�����$INSTDIR\w64������Щ�ļ�����ԭ�棬δ�����ܻᱻСС���뷨����dgod���¡�
 		SetOutPath $INSTDIR\w64
		File w64\libcloud.so
		File w64\libgbk.so
		File w64\libl.dll
		File w64\libmb.so
		File w64\yong.exe
		File w64\yong-config.exe
		File w64\yong-vim.exe
		# ��װ32λ�������ļ��������Դ�ļ�����Щ�ļ�����ԭ�棬δ�����ܻᱻСС���뷨����dgod����
		SetOutPath $INSTDIR
		File yong.exe
		File yong-config.exe
		File yong-vim.exe
		File libmb.so
		File libgbk.so
		File libcloud.so
		File libl.dll
		File class.txt
		File README.txt
		#File yong.chm
		File normal.txt
		# ��װ�����Դ�ļ�����Щ�ļ�����xxxk������thXnder���ƣ���δ����̫���ܱ�dgod����
		File bihua.bin
		File bd.txt
		File keyboard.ini
		File yong.ini # Ĭ���趨�ļ������û��趨�ļ�$yongdir\yong.ini������ʱ���Ż���ø��ļ�
		File menu.ini
		WriteINIStr $INSTDIR\menu.ini "about" "exec" "$$MSG(v${PRODUCT_VERSION}-Build${PRODUCT_VERSION_MINOR})" #���治�������ģ����������
		File crab.txt
		File layout.txt
		File urls.txt
		#
		# ����TSFģ�飨��$INSTDIR\tsf��
		Detailprint "����TSFģ��..."
		SetOutPath $INSTDIR\tsf
		# ���yong.dll��
		${If} ${FileExists} $INSTDIR\tsf\yong.dll
				ExecWait '"$INSTDIR\tsf\tsf-reg.exe" -u -d' # ��ע��ɰ�dll
				# �ɰ�dll��ע����Կ��ܱ��Ѵ򿪵ĳ���ռ�ã������Ը�����������ǲ�ֱ��ɾ�������Ǹ��ļ�������.del��ǣ����´�ִ�а�װ��ʱ���ٳ���ɾ��
				StrCpy $1 0
				${While} ${FileExists} $INSTDIR\tsf\yong-$oldver-$1.del
						IntOp $1 $1 + 1
				${EndWhile}
				Rename $INSTDIR\tsf\yong.dll $INSTDIR\tsf\yong-$oldver-$1.del
		${EndIf}
		# ���yong64.dll�ȣ���ʹ��32λ�����뷨��Ҳ���ܻ�ͬʱ�õ�yong.dll��yong64.dll��
		${If} ${FileExists} $INSTDIR\tsf\yong64.dll
				ExecWait '"$INSTDIR\tsf\tsf-reg64.exe" -u -d' # ��ע��ɰ�dll
				# �ɰ�dll��ע����Կ��ܱ��Ѵ򿪵ĳ���ռ�ã������Ը�����������ǲ�ֱ��ɾ�������Ǹ��ļ�������.del��ǣ����´�ִ�а�װ��ʱ���ٳ���ɾ��
				StrCpy $1 0
				${While} ${FileExists} $INSTDIR\tsf\yong64-$oldver-$1.del
						IntOp $1 $1 + 1
				${EndWhile}
				Rename $INSTDIR\tsf\yong64.dll $INSTDIR\tsf\yong64-$oldver-$1.del
		${EndIf}
		# �ͷ�����tsf�ļ�
		File tsf\yong.dll
		File tsf\yong64.dll
		File tsf\tsf-reg.exe
		File tsf\tsf-reg64.exe
		File tsf\install.bat # ��Ұ����ͨ��ִ��install.bat�ļ�����Ϊ��װ��
		File tsf\uninstall.bat
		Delete $INSTDIR\tsf\*.del # ɾ����.del��ǵ��ļ����������/REBOOTOK������������ɾ��ʧ��ʱ��ʾ����
		#
		#
		# ���ι��ܣ�������ݷ�ʽ��ע�����
		# �������������Ԥ���峣����$INSTDIR��$yongdir��$oldver
		# ���������������
		
		${IfNot} ${RunningX64}
				!insertmacro SetSecChk ${SecX64} 0 # ��ֹ��32λϵͳ��ǿ�й�ѡ64λ
		${EndIf}
		
		# �����ǽ����ڰ�װ��Ĳ���
		${Unless} ${SectionIsSelected} ${SecPortable}
				# �ͷ�ж�س���
				WriteUninstaller $INSTDIR\uninstall.exe
				# дע���
				Detailprint "д��ע���..."
				WriteRegStr HKCU "Control Panel\Desktop" "LowLevelHooksTimeout" 0x000003E8 # �޸�ע���
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
				WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallProgram" "$INSTDIR\yong.exe"
				# ��ݷ�ʽ
				Detailprint "������ݷ�ʽ..."
				${If} ${SectionIsSelected} ${SecX64}
				    CreateShortCut "$INSTDIR\СС�ǿ�.lnk" "$INSTDIR\w64\yong.exe"
				${Else}
				    CreateShortCut "$INSTDIR\СС�ǿ�.lnk" "$INSTDIR\yong.exe"
				${EndIf}
				# ��ʼ�˵�
				Delete "$SMSTARTUP\yong.lnk"
				${If} ${SectionIsSelected} ${SecX64}
				    CreateShortCut "$SMSTARTUP\yong.lnk" "$INSTDIR\w64\yong.exe" # ��ݷ�ʽ������Ϊyong.lnk�����ܺ����뷨��Ĭ�����ó���yong-config.exe���
				${Else}
				    CreateShortCut "$SMSTARTUP\yong.lnk" "$INSTDIR\yong.exe" # ��ݷ�ʽ������Ϊyong.lnk�����ܺ����뷨��Ĭ�����ó���yong-config.exe���
				${EndIf}
				RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}" # ɾ����ʼ->����->СС�ǿ���Ŀ�ݷ�ʽ�����ؽ�
				CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\1.СС�ǿ�.lnk" "$INSTDIR\tools\bat\rerun.bat" "" "$INSTDIR\yong.exe"
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\2.����СС.lnk" "$INSTDIR\tools\bat\reset.bat" "" "$WINDIR\System32\SHELL32.dll" 238
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\3.�̳�.lnk" "$INSTDIR\doc" "" "$WINDIR\System32\SHELL32.dll" 23
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\4.����.lnk" ${PRODUCT_WEB_SITE} "" "$WINDIR\System32\SHELL32.dll" 17
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\5.����.lnk" "http://xxjd.ys168.com/" "" "$WINDIR\System32\SHELL32.dll" 17
				CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\6.ж��.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
				# ע��TSFģ�飨��64λ����ϵͳ�ϣ���ʹֻ��32λ��yong.exe��Ҳ��Ҫͬʱע��32λ��64λ��dll��
				DetailPrint "ע��TSFģ��..."
				SetOutPath $INSTDIR\tsf
				ExecWait '"$INSTDIR\tsf\tsf-reg.exe" -i'
				ExecWait '"$INSTDIR\tsf\tsf-reg64.exe" -i'
		${EndUnless}
SectionEnd
Section "-��װƤ�����ĵ����ű�" SecInstOtherFiles
		# ��װƤ������$INSTDIR\skin��
		DetailPrint "��װƤ��..."
		SetOutPath $INSTDIR\skin
		File skin\*.* # Ƥ�������̺�ͼ���ļ���*.*��ʾ������Ŀ¼��ֻ�����ļ��������Ͳ��������ʱ������Ƥ������Ŀ¼��Ҳһ��Ū������
		#
		# ��װ�ĵ�����$INSTDIR\doc\����$INSTDIR\doc\������
		DetailPrint "��װ�ĵ�..."
		SetOutPath $INSTDIR\doc
		File /r doc\* # *��ʾ����Ŀ¼��/r��ʾ������Ŀ¼
		#
 		# ��װ�ű�����$INSTDIR\tools\vbs��$INSTDIR\tools\bat��
		DetailPrint "��װ�ű�..."
		Delete $INSTDIR\tools\bat\exit.bat # ��ɾ����ʷ�����ľɽű�
		SetOutPath $INSTDIR\tools\vbs
		File /r tools\vbs\* # *��ʾ����Ŀ¼��/r��ʾ������Ŀ¼
		SetOutPath $INSTDIR\tools\bat
		File /r tools\bat\*
		${If} ${SectionIsSelected} ${SecX64}
				Delete yong.bat
				Delete yong-config.bat
				Rename yong64.bat yong.bat
				Rename yong-config64.bat yong-config.bat
		${Else}
				Delete yong64.bat
				Delete yong-config64.bat
		${EndIf}
SectionEnd
Section "-��װ���" SecInstMbFiles
		DetailPrint "��װ���..."
		# �Ȱ����з������ͷŵ�$TEMP\mb�������ת�Ƶ�$INSTDIR\mb�֮������ô��������ֱ�����������ѡ�����ͷŷ�����������ΪNSIS��һ�������Ǹ���File�����Զ��ж�Ҫ����Щ�ļ��������װ��������File���������������ʹ�ã��û��ƽ�ʧЧ��������Ӧ�ļ����ᱻ���뵽��װ���
		RMDir /r $TEMP\mb
		SetOutPath $TEMP\mb
		File /r mb\*
		RMDir /r $INSTDIR\mb\delete
		SetOutPath $INSTDIR\mb\delete # ȷ��Ŀ¼���ڣ��Ա�֤��һ��Ҫ�õ�Rename����˳��ִ��
		${Locate} "$TEMP\mb" "/L=D /G=0" "EachDirInMbTemp" # ����ָ��Ŀ¼($TEMP\mb)�µ�һ��(/G=0)��Ŀ¼(/L=D)����ÿ��������ú���EachDirInMbTemp�������ǰѸ���Ŀ¼ת�Ƶ�$INSTDIR\mb��$INSTDIR\mb��ͬ����Ŀ¼����ת�Ƶ�$INSTDIR\mb\delete��
		# ��װӢ�����
		SetOutPath $INSTDIR\mb
		File mb\english.txt
		# �ͷ�entry
		SetOutPath $INSTDIR\entry
		File entry\*.ini
SectionEnd
Function EachDirInMbTemp
		# $R6-��С  $R7-����  $R8-��·��  $R9-��·��\����
		${IfThen} ${FileExists} $INSTDIR\mb\$R7 ${|} Rename $INSTDIR\mb\$R7 $INSTDIR\mb\delete\$R7 ${|} # ������ж��ļ��Ƿ���ھ���Rename���ᵼ�±�������
		CopyFiles /SILENT $TEMP\mb\$R7\* $INSTDIR\mb\$R7
		Push $0
FunctionEnd
#
Section "-�ָ�yongdir\yong.ini" SecSetUser
# ���ι��ܣ�����$INSTDIR\yong.iniΪģ�彨��$TEMP\yong.ini���ڻָ�$yongdir\yong.ini�еĲ����趨��$TEMP\yong.ini���������ҳ��ѡ�ˡ������趨���������˲�������ʹ$TEMP\yong.ini��Ϊ�µ�$yongdir\yong.ini
# �������������Ԥ���峣����$INSTDIR��$yongdir����Ϊʹ����$yongdir�������α���ŵ�.onVerifyInstDir����֮��
# ���������������
		Detailprint "���������ļ�..."
		Step1:
		Delete $TEMP\yong.ini
		CopyFiles /SILENT $INSTDIR\yong.ini $TEMP\yong.ini
#
		Step2:
		# ������������ûָ�
		${IfThen} ${SectionIsSelected} ${SecClearUser} ${|} Goto Step3${|} # ��ѡ�������趨��ʱ
		${IfNotThen} ${FileExists} $yongdir\yong.ini ${|} Goto Step3 ${|} # $yongdir\yong.ini������ʱ
		# ������������лָ����Ȼָ��������׻ָ����趨����Щ�趨����ע�͵�����Ŀ�������yong-config.exe��Ҳ�����޸ġ�
		# IM�Σ���������أ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "cand"								# ��ѡ����
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "lang"								# ��ʼ��Ӣ
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "s2t"								# ��ʼ��
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "s2t_m"							# ��һ�Զ�ת��
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "filter"								# ���ֹ���
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "enable"							# ���ģʽ�£����к��Զ�����״̬��
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "skin"								# Ƥ��
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "enter"							# �س�����Ϊ
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "num"								# ��������ּ���Ϊ
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "keypad"							# С�������ּ���Ϊ
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "space"							# �ո�����
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "onspot"							# Ԥ�༭����
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "preedit"							# Ԥ�༭���
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "auto_move"							# �Զ���Ƶ��������������е�����
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "ABCD"							# SHIFT+��ĸֱ�ӳ���ĸ
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "CNen_commit"						# ����Ӣ���л���ʱ����ѡ���е�����������δ���
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "alt_bd_disable"						# ��סAlt��ʱ����ʱ�л���Ӣ�ı��״̬
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "sym_in_num"							# ��Щ���ŵ�ȫ��ģʽ�������ֺ���֣��Զ���ɰ��
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "caps_bd"							# ����ģʽ+��д����ʱ�������Ӣ״̬
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "dict_en"							# Ӣ��״̬��������ѯ��ַ
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "IM" "dict_cn"							# ����״̬��������ѯ��ַ
		# main�Σ�״̬����أ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "tray"							# ��ʾ����ͼ��
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "noshow"							# ����״̬��
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "tran"							# ״̬����͸��
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "pos"							# ״̬������Ļ�ϵ�λ��
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "menu.ini"							# ���ò˵�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "main" "tip"								# ��������
		# input�Σ���ѡ����أ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "hint"							# ������ʾ
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "root"							# ������
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "a_caret"							# �����淽ʽ
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "noshow"							# ���غ�ѡ��
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "strip"							# ��ѡ�������ʾ�೤�ı���
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "font"							# ��ѡ���������
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "input" "select"							# ��ѡ�������ʽ
		# key�Σ��ȼ���أ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "trigger"							# ����״̬���Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "select"							# ������ѡ��ݼ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "select_n"							# ��ѡ��ݼ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "CNen"							# ��Ӣ���л���ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "tEN"								# ����ģʽ�л���ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "switch"							# ���뷽���л���ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "switch_default"						# �л���Ĭ�����뷽���Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "switch_4"							# �л���4�����뷽����ݼ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "page"							# ��ҳ��ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "w2c"								# �Դʶ��ֿ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "filter"							# ��ʱȡ�����˵Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "move"							# ����Ƶ�Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "ishow"							# ��ʱ��ʾ��ѡ���Ŀ�ݼ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "mshow"							# ��ʱ��ʾ״̬���Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "s2t"								# ���л��Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "replace"							# �滻������û�ã�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "query"							# ������Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "dict"								# ������ѯ�Ŀ�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "bihua"							# �ʻ�ģʽ������
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "zi_switch"							# ����ģʽ�л���ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "keyboard"							# ����̿�ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "corner"							# ȫ����л���ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "biaodian"							# ��Ӣ�ı���л���ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "tools[0]"							# ����ָ�������ݼ�
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "key" "keymap"							# ��λͼ��ݼ�
		# table�Σ������أ�
		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "edit"							# ���Ĭ�ϱ༭��
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "zi_mode"							# ����ģʽ
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "adict"							# ��Ϊ1��Ѹ������Ҳ��Ϊ��������
#		!insertmacro CopyINIKey "$yongdir\yong.ini" "$TEMP\yong.ini" "table" "wildcard"							# ���ܼ�������������е�����
#
    # �������ָ��Ƚϸ��ӵ�[IM]����ż���[����ID]�Ρ�
		# ����Ӧ��֪������$yongdir\yong.ini�У�ͬһ����������ż���[����ID]��Ӧ�ñ��֡�Ҫô���У�Ҫô��û�У�����yong-config.exe����ӣ�����״̬��������ֻ��һ�ߡ�
		#�����ֻ����ż���û����Ӧ��[����ID]�Σ��ᵼ��yong-config.exe�ظ�ʶ��÷���������ļ������ֻ��[����ID]��û����Ӧ����ż����ᵼ��yong-config.exeʶ�𲻵��÷���������ļ���
		# �����ȷ���λָ���Ŀ��Ϊ����$TEMP\yong.ini��[IM]����ż���[����ID]�ξ�����ԭΪ$yongdir\yong.ini��״̬�����Ƕ������÷���Ӧ���и��Ǹ��£����ڴ�������ż���[����ID]��ȱһ��Ӧ����������
		#
		# $TEMP\yong.ini�ĳ�ʼ״̬��[IM]0=pinyin��[IM]default=0��[pinyin]��(��ʾ���������趨��)���벻Ҫ������$INSTDIR\yong.ini�����������������ż���[����ID]�Ρ�
		DeleteINISec $TEMP\yong.ini pinyin # �����$TEMP\yong.ini��ԭ�е�[����ID]��
		#
		# ����$yongdir\yong.ini�У�[IM]������ż�0~99��ֵ����.
		#		A:���Ǳ��������÷������оݣ�$INSTDIR\entryĿ¼�д�����Ӧ�ķ���ID_entry.ini����ļ������Ͳ��ø���ż�������ID_entry.ini���[����ID]�ε�$TEMP\yong.ini��
		#   B:����B1:������ȱ������������Ӧ��[����ID]�Σ����Ͳ��ø���ż���[����ID]�ε�$TEMP\yong.ini��
		#						B2:������ȱ�������򲻲��ø÷�����$TEMP\yong.ini�У��ǵñ�֤$TEMP\yong.ini����ż���������
		# ռ��һ��$0~$9
		StrCpy $9 "-1" # $9������¼$TEMP\yong.ini�еķ������
		${For} $0 0 99 # $0��������$yongdir\yong.ini�еķ������
		    ReadINIStr $1 "$yongdir\yong.ini" "IM" "$0" # $1��¼$0��Ӧ�ķ���ID
				${If} ${FileExists} "$INSTDIR\entry\$1_entry.ini"
				    # A
            IntOp $9 $9 + 1
						WriteINIStr "$TEMP\yong.ini" "IM" "$9" "$1"
						!insertmacro CopyINISec "$INSTDIR\entry\$1_entry.ini" "$TEMP\yong.ini" "$1" # ��������
				${Else}
				    # B
				    ReadINIStr $2 "$yongdir\yong.ini" "$1" "name"  # $2��һ��flag�������������ȱ�ģ�$2Ӧ��Ϊ��
				    ${IfNot} $2 == "" # B1
		            IntOp $9 $9 + 1
								WriteINIStr "$TEMP\yong.ini" "IM" "$9" "$1"
								!insertmacro CopyINISec "$yongdir\yong.ini" "$TEMP\yong.ini" "$1" # ��������
				    ${EndIf}
				${EndIf}
		${Next}
		#
		# $0~$8���ͷţ�$9��$TEMP\yong.ini�е���󷽰����
		#
		# ���Ի�ԭdefault��Ĭ��Ϊ0��
		WriteINIStr "$TEMP\yong.ini" "IM" "default" "0"
		ReadINIStr $0 "$yongdir\yong.ini" "IM" "default"
		ReadINIStr $1 "$yongdir\yong.ini" "IM" "$0" # ��ȡ$yongdir\yong.ini��default����ID��$1
    ReadINIStr $2 "$TEMP\yong.ini" "$1" "name"  # $2��һ��flag�����������жϸ÷���ID��$TEMP\yong.ini���Ƿ����
		${IfNot} $2 == "" # ���ڣ���һ���жϸ÷���ID��$TEMP\yong.ini�ж�Ӧ����ż�
				${For} $3 0 $9 # $3��������$TEMP\yong.ini�еķ������
				    ReadINIStr $4 "$TEMP\yong.ini" "IM" "$3" # ��ȡ����ID����$4
				    ${If} $4 == $1
				        WriteINIStr "$TEMP\yong.ini" "IM" "default" "$3"
				    ${EndIf}
				${Next}
		${EndIf}
		# �������ͷţ�$9���ܻ�����
		
		Step3:
		# Ϊ��Ӧ����ȷ������pinyin����
    ReadINIStr $2 "$TEMP\yong.ini" "pinyin" "name"  # $2��һ��flag�������pinyin������$2Ӧ��Ϊ��
    ${If} $2 == ""
        IntOp $9 $9 + 1
				WriteINIStr "$TEMP\yong.ini" "IM" "$9" "pinyin"
				!insertmacro CopyINISec "$INSTDIR\entry\pinyin_entry.ini" "$TEMP\yong.ini" "pinyin" # ��������
    ${EndIf}
		# ֻ��1����������Ϊpinyin��ʱ��׷�Ӽ�������
		${If} $9 < 1
	      IntOp $9 $9 + 1
				WriteINIStr "$TEMP\yong.ini" "IM" "$9" "xkjd6"
				!insertmacro CopyINISec "$INSTDIR\entry\xkjd6_entry.ini" "$TEMP\yong.ini" "xkjd6" # ��������
				WriteINIStr "$TEMP\yong.ini" "IM" "default" "1" # ��Ĭ�Ϸ�����Ϊ����
    ${EndIf}
    # Ӧ�������ļ�
		CopyFiles /SILENT $TEMP\yong.ini $yongdir\yong.ini
		# �������ͷţ�$9���ܻ�����
SectionEnd
#
Function .onInstSuccess
    # ���û��Ƿ��ͼ�����ó���
		MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON1 "$\n�Ƿ�Ϊ����ͼ�λ����ó���$\n�����������й������뷽�������߽���һЩ���Ի����ơ�$\n��Ҳ����ͨ����ʼ�˵��������뷨״̬������ͼ�λ����ó���" \
				   /SD IDYES IDNO skip
		ExecShell "open" "$INSTDIR\tools\bat\yong-config.bat" # �����ó���
		skip:
FunctionEnd

Function ж�س���
#    ������ע��
FunctionEnd
# �Ӵˣ�INSTDIRָuninstall.exe����Ŀ¼
# ж��ǰ
Function un.onInit
		MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" \
				   /SD IDYES IDYES +2
		Abort
FunctionEnd


# ж��ʱ
Section "Uninstall"
		# ��Ⲣ�ر�������
		loop:
		FindWindow $0 "yong_main"
		IntCmp $0 0 done
		SendMessage $0 2 0 0
		Sleep 444
		Goto loop
		done:

		# ɾ����ݷ�ʽ
		RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
		Delete "$SMSTARTUP\yong.lnk"
		Delete "$INSTDIR\*.lnk"

		# ��ע��tsf
		IfFileExists "$INSTDIR\tsf\tsf-reg.exe" 0 +2
		ExecWait '"$INSTDIR\tsf\tsf-reg.exe" -u -d'

		IfFileExists "$INSTDIR\tsf\tsf-reg64.exe" 0 +2
		ExecWait '"$INSTDIR\tsf\tsf-reg64.exe" -u -d'

		# ɾ��yongĿ¼�µ���Ҫ�ļ�
		RMDir /r "$INSTDIR\tsf"
		RMDir /r "$INSTDIR\mb"
		RMDir /r "$INSTDIR\skin"
		RMDir /r "$INSTDIR\w64"
		RMDir /r "$INSTDIR\entry"
		RMDir /r "$INSTDIR\doc"
		RMDir /r "$INSTDIR\tools"
		RMDir /r "$INSTDIR\userdict"
		Delete "$INSTDIR\yong.exe"
		Delete "$INSTDIR\yong-config.exe"
		Delete "$INSTDIR\yong-vim.exe"
		Delete "$INSTDIR\libmb.so"
		Delete "$INSTDIR\libgbk.so"
		Delete "$INSTDIR\libcloud.so"
		Delete "$INSTDIR\libl.dll"
		Delete "$INSTDIR\README.txt"
		Delete "$INSTDIR\yong.ini"
		Delete "$INSTDIR\class.txt"
		Delete "$INSTDIR\bd.txt"
		Delete "$INSTDIR\bihua.bin"
		Delete "$INSTDIR\keyboard.ini"
		Delete "$INSTDIR\normal.txt"
		Delete "$INSTDIR\learn.dat"
		Delete "$INSTDIR\yong.chm"
		Delete "$INSTDIR\menu.ini"
		Delete "$INSTDIR\crab.txt"
		Delete "$INSTDIR\layout.txt"
		Delete "$INSTDIR\urls.txt"

		# ɾ���Լ�
		Delete "$INSTDIR\uninstall.exe"

		# �����û��趨.yong
		MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "�Ƿ����û��趨��" \
		           /SD IDYES IDYES +3
		RMDir /r "$APPDATA\yong"
		RMDir /r "$INSTDIR\.yong"
		
		ExecShell "open" "$INSTDIR" # �򿪸��û���

		# ɾ��ע���
		DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

SectionEnd

# ж�غ�
Function un.onUninstSuccess
		HideWindow
		MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���\
		                                     $\n��װĿ¼����в����ļ��������󼴿�ɾ����\
											 									 $\n��Ҳ���Բ�����ֱ�Ӱ�װ�°��СС�ǿա�" \
				   			/SD IDOK
FunctionEnd
