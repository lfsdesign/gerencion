import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // --- TODA A SUA INTELIGÊNCIA PRESERVADA ---
  final TextEditingController _senhaController = TextEditingController();
  bool _erroSenha = false;
  bool _mostrarSenha = false;
  final String _senhaCorreta = "1234";
  
  final String nomeUsuario = "Leandro Felipe";
  final String empresaUsuario = "Fometto Representações Ltda";
  final Color corDestaqueAzul = const Color(0xFF1A73E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2A), 
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 320, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. LOGO SVG - Espaço reduzido para subir o formulário
                const SizedBox(height: 0),
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 200,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 0), // Espaço ajustado para o formulário subir

                // 2. DADOS DE LOGIN
                
                _buildDadoLogin(Icons.business_outlined, empresaUsuario), 
                _buildDadoLogin(Icons.person_outline, "1010 - $nomeUsuario"),
                
                // 3. CAMPO DE SENHA - ALINHADO E CORRIGIDO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Senha",
                      hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 16),
                      isDense: true, 
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 10, bottom: 6),
                        child: Icon(Icons.lock_outline, color: Color(0xFF1A73E8), size: 22),

                      ),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white38, size: 20,
                        ),
                        onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                      ),
                      // CORREÇÃO CIRÚRGICA: _erroSenha com underline
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _erroSenha ? Colors.red : Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _erroSenha ? Colors.red : const Color(0xFF1A73E8), width: 2),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        if (val.isEmpty) {
                          _erroSenha = false;
                        } else {
                          _erroSenha = !_senhaCorreta.startsWith(val);
                        }
                      });
                    },
                  ),
                ),

                // 4. TARJA VERMELHA DE ERRO
                if (_erroSenha)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    padding: const EdgeInsets.all(8),
                    color: Colors.red,
                    child: Text(
                      "SENHA INVÁLIDA",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 40),

                // 5. BOTÃO ENTRAR - ESTILO CANVA
                InkWell(
                  onTap: () {
                    if (_senhaController.text == _senhaCorreta) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeGerencion(nomeUsuario: nomeUsuario, empresaUsuario: empresaUsuario)),
                      );
                    } else {
                      setState(() => _erroSenha = true);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ENTRAR",
                        style: GoogleFonts.inter(
                          color: corDestaqueAzul,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: corDestaqueAzul, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDadoLogin(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: corDestaqueAzul, size: 20),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  texto,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(color: Colors.white12, thickness: 1),
        ],
      ),
    );
  }
}