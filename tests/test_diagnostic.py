import json, os, pathlib, sqlite3, subprocess, tempfile, unittest
ROOT=pathlib.Path(__file__).resolve().parents[1]
class Diagnostic(unittest.TestCase):
    def test_complete_negative_and_positive_read_only(self):
        for healthy in [False,True]:
            with self.subTest(healthy=healthy), tempfile.TemporaryDirectory(prefix='doctor space ') as td:
                home=pathlib.Path(td); config=home/'.openclaw'; config.mkdir()
                if healthy:
                    (config/'memory').mkdir()
                    db = sqlite3.connect(config/'memory/main.sqlite')
                    db.execute('PRAGMA journal_mode=wal')
                    db.close()
                    (config/'openclaw.json').write_text(json.dumps({'plugins':{'entries':{'memory-core':{'enabled':True}}},'models':{'providers':{'fixture':{}}},'auth':{'profiles':{'fixture':{}}}}))
                else: (config/'openclaw.json').write_text('{}')
                bin=home/'bin'; bin.mkdir(); cli=bin/'openclaw'
                cli.write_text('#!/bin/sh\ntouch "$HOME/UNEXPECTED_RUNTIME"\nexit 90\n'); cli.chmod(0o755)
                def snapshot(): return {str(p.relative_to(home)):p.read_bytes() for p in home.rglob('*') if p.is_file()}
                before=snapshot()
                p=subprocess.run(['bash',str(ROOT/'auto-diagnostic.sh'),'--read-only'],env={**os.environ,'HOME':td,'PATH':str(bin)+':'+os.environ['PATH']},capture_output=True,text=True)
                self.assertEqual(p.returncode,0 if healthy else 1,p.stdout+p.stderr)
                self.assertIn('БЕЗОПАСНОСТЬ',p.stdout)
                self.assertIn('NOT_RUN (read-only)',p.stdout)
                self.assertEqual(snapshot(),before)
if __name__=='__main__': unittest.main()
