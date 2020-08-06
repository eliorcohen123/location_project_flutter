package com.eliorcohen.locationprojectflutter

import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity

class CreditActivity : FlutterActivity(), View.OnClickListener {

    private var buttonOK: Button? = null
    private var emailElior: ImageView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_credit)

        initUI()
        initListeners()
    }

    private fun initUI() {
        buttonOK = findViewById(R.id.buttonOK)
        emailElior = findViewById(R.id.emailElior)
    }

    private fun initListeners() {
        buttonOK?.setOnClickListener(this)
        emailElior?.setOnClickListener(this)
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.buttonOK -> {
                finish()
            }
            R.id.emailElior -> {
                val i = Intent(Intent.ACTION_SEND)
                i.type = "message/rfc822"
                i.putExtra(Intent.EXTRA_EMAIL, arrayOf("eliorjobcohen@gmail.com"))
                try {
                    startActivity(Intent.createChooser(i, "Send mail..."))
                } catch (ex: ActivityNotFoundException) {
                    Toast.makeText(this, "There are no email clients installed.", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

}
