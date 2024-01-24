#INCLUDE "TOTVS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCadZA1 � Autor � Juliano Junio       � Data �  26/11/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro Fabricantes                  .                    ���
�������������������������������������������������������������������������͹��
���Uso       � Century.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fCadZA1()
Private cString   := "ZA1"
Private cEmpresa  := Upper(SubStr(Alltrim(SM0->M0_NOME),1,1)) + Lower(SubStr(Alltrim(SM0->M0_NOME),2,Len(Alltrim(SM0->M0_NOME)))) + " / " + Upper(SubStr(Alltrim(SM0->M0_FILIAL),1,1)) + Lower(SubStr(Alltrim(SM0->M0_FILIAL),2,Len(Alltrim(SM0->M0_FILIAL))))
Private oBrowse
Private cRotina   := "Fabricantes " + cEmpresa +")"
Private aRotina   := MenuDef()
Private cCadastro := cRotina

// - Monta Objeto MVC Browser.
oBrowse:= FWmBrowse():New()
oBrowse:SetDescription(cRotina)
oBrowse:SetWalkThru(.F.)
oBrowse:SetAlias(cString)
oBrowse:DisableDetails()
// - Ativa o Objeto Browser para sua exibicao.
oBrowse:Activate()
Return

***********************
// Monta Painel de Controle do Browser Principal.
Static Function MenuDef()
Local aRotina := {}

// - Adciona itens ao Array aRotina.
ADD OPTION aRotina Title 'Pesquisar' Action "AxPesqui" OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Visualizar' Action "AxVisual" OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir' Action "U_fCadZA1M(3)" OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action "U_fCadZA1M(4)" OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir' Action "U_fCadZA1M(5)" OPERATION 5 ACCESS 0

Return aRotina
**************************************************************************************************************************************************************************

/*
AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea,lFlat,lSubst)
AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea,lFlat)
Function AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons,aParam,aAuto,lMaximized,cTela,aAcho,lPanelFin,oFather,aDim, lFlat)				
*/				

// Fun��o principal que chama AxInclui
User Function fCadZA1M(nOpc)
	Local cTudoOk := "U_fUpdZA1()"

	If nOpc == 3	// Inclus�o
		AxInclui("ZA1", 0, 3, ,,,cTudoOk)
	ElseIf nOpc == 4
		AxAltera("ZA1", ZA1->(Recno()), 4, ,,,,cTudoOk)
	ElseIf nOpc == 5
		AxDeleta("ZA1", ZA1->(Recno()), 5)
	EndIf

Return


/*/ {Protheus.doc} Function
// Fun��o est�tica que faz o reclock e o update
*/

User Function fUpdZA1()
   // Construa a instru��o SQL para realizar o update
   Local cSQL := "UPDATE " + RetSqlName("SA5") + ;
                   " SET A5_FABR = '" + M->ZA1_FABRI + "'" + ;
                 " WHERE A5_FILIAL = '" + xFilial("SA5") + "' AND A5_XFABR = '" + M->ZA1_CODIGO + "'"

   // Execu��o do update
   If (TCSQLExec(cSQL) <> 0)
      // Se houver um erro, emita uma mensagem de erro
      Help(,, "fUpdZA1",, "Erro ao atualizar A5_FABR [" + cSQL + "]", 1, 0)
      Return .F.
   EndIf

Return .T.
